package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"syscall"

	MQTT "github.com/eclipse/paho.mqtt.golang"
)

func subscribe(client MQTT.Client, c chan []byte) {
	handler := MQTT.MessageHandler(func(client MQTT.Client, message MQTT.Message) {
		c <- message.Payload()
	})

	if token := client.Subscribe("pc/desktop/hibernate", 1, handler); token.Wait() && token.Error() != nil {
		log.Printf("Subscription failure: %s", token.Error())
		os.Exit(1)
	}
}

func main() {
	fmt.Println("Started")
	var stopping = make(chan os.Signal)
	signal.Notify(stopping, syscall.SIGTERM)
	signal.Notify(stopping, syscall.SIGINT)

	opts := MQTT.NewClientOptions()
	opts.AddBroker("192.168.1.110:1883")
	opts.SetClientID("mq-control-desktop")

	client := MQTT.NewClient(opts)
	if token := client.Connect(); token.Wait() && token.Error() != nil {
		log.Printf("Connection failure: %s", token.Error())
		panic(token.Error())
	}

	msg := make(chan []byte)

	go subscribe(client, msg)

	for {
		select {
		case payload := <-msg:
			fmt.Printf("Received message: %s\n", payload)
			cmd := exec.Command("sh", "-c", "ls")
			cmd.Stderr = os.Stderr
			cmd.Stdout = os.Stdout
			if err := cmd.Run(); err != nil {
				log.Fatal(err)
			}

		case <-stopping:
			fmt.Println("Stopping")
			client.Disconnect(250)
			fmt.Println("Stopped")
			os.Exit(0)
		}
	}
}
