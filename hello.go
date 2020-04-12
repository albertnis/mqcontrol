package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"

	MQTT "github.com/eclipse/paho.mqtt.golang"
)

func subscribe(client MQTT.Client, c chan []byte) {
	handler := MQTT.MessageHandler(func(client MQTT.Client, message MQTT.Message) {
		c <- message.Payload()
	})

	if token := client.Subscribe("pc/desktop/hibernate", 1, handler); token.Wait() && token.Error() != nil {
		fmt.Printf("Subscription failure: %s", token.Error())
		os.Exit(1)
	}
}

func main() {
	fmt.Println("Started")
	stopping := make(chan os.Signal)
	signal.Notify(stopping, syscall.SIGTERM)
	signal.Notify(stopping, syscall.SIGINT)

	opts := MQTT.NewClientOptions()
	opts.AddBroker("192.168.1.110:1883")
	opts.SetClientID("mq-control-desktop")

	client := MQTT.NewClient(opts)
	if token := client.Connect(); token.Wait() && token.Error() != nil {
		fmt.Printf("Connection failure: %s", token.Error())
		panic(token.Error())
	}

	msg := make(chan []byte)

	go subscribe(client, msg)

	for {
		select {
		case payload := <-msg:
			fmt.Println(payload)
		case <-stopping:
			fmt.Println("Stopping")
			client.Disconnect(250)
			fmt.Println("Stopped")
			os.Exit(0)
		}
	}
}
