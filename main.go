package main

import (
	"encoding/csv"
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"strings"
	"syscall"

	MQTT "github.com/eclipse/paho.mqtt.golang"
)

type config struct {
	Command  string
	Topic    string
	Broker   string
	ClientID string
	User     string
	Password string
}

func subscribe(client MQTT.Client, topic string, msg chan []byte) {
	handler := MQTT.MessageHandler(func(client MQTT.Client, message MQTT.Message) {
		payload := message.Payload()
		log.Printf("Message received on topic %s: %s\n", topic, payload)
		msg <- payload
	})

	log.Printf("Subscribing to topic %s... ", topic)
	token := client.Subscribe(topic, 1, handler)
	token.Wait()
	if token.Error() != nil {
		log.Fatal(token.Error().Error())
	}
	log.Println("Subscription successful")
}

func createOnConnectHandler(topic string, msg chan []byte) MQTT.OnConnectHandler {
	return func(client MQTT.Client) {
		log.Println("Client connected")
		go subscribe(client, topic, msg)
	}
}

func main() {
	var stopping = make(chan os.Signal)
	signal.Notify(stopping, syscall.SIGTERM)
	signal.Notify(stopping, syscall.SIGINT)

	commandPtr := flag.String("c", "", "Command to run when any message received on topic")
	topicPtr := flag.String("t", "computer/command", "Topic to subscribe to")
	brokerPtr := flag.String("h", "127.0.0.1:1883", "Address and port of MQTT broker")
	clientIDPtr := flag.String("i", "mqcontrol", "ID to use for this client")
	userPtr := flag.String("u", "", "Username for MQTT connection")
	passwordPtr := flag.String("P", "", "Password for MQTT connection")

	flag.Parse()

	conf := config{
		Command:  *commandPtr,
		Topic:    *topicPtr,
		Broker:   *brokerPtr,
		ClientID: *clientIDPtr,
		User:     *userPtr,
		Password: *passwordPtr,
	}

	if conf.Topic == "" {
		fmt.Println("No topic argument provided")
		fmt.Fprintf(os.Stderr, "Usage of %s:\n", os.Args[0])
		flag.PrintDefaults()
		os.Exit(1)
	}
	if conf.Command == "" {
		fmt.Println("No command argument provided")
		fmt.Fprintf(os.Stderr, "Usage of %s:\n", os.Args[0])
		flag.PrintDefaults()
		os.Exit(1)
	}

	r := csv.NewReader(strings.NewReader(conf.Command))
	r.Comma = ' '
	commandFields, err := r.Read()
	if err != nil {
		log.Fatal(err.Error())
	}

	opts := MQTT.NewClientOptions()
	opts.AddBroker(conf.Broker)
	opts.SetClientID(conf.ClientID)
	opts.SetUsername(conf.User)
	opts.SetPassword(conf.Password)
	opts.SetAutoReconnect(true)

	opts.SetConnectionLostHandler(func(c MQTT.Client, err error) {
		log.Println("Client connection lost unexpectedly")
	})

	msg := make(chan []byte)
	opts.SetOnConnectHandler(createOnConnectHandler(conf.Topic, msg))

	log.Printf("Connecting to client %s... ", conf.Broker)
	client := MQTT.NewClient(opts)
	if token := client.Connect(); token.Wait() && token.Error() != nil {
		log.Fatal(token.Error().Error())
	}

	for {
		select {
		case <-msg:
			cmd := exec.Command(commandFields[0], commandFields[1:]...)
			cmd.Stderr = os.Stderr
			cmd.Stdout = os.Stdout
			if err := cmd.Run(); err != nil {
				log.Fatal(err.Error())
			}

		case <-stopping:
			log.Println("Application is being stopped")
			log.Printf("Disconnecting from client %s... ", conf.Broker)
			client.Disconnect(250)
			log.Println("Success")
			os.Exit(0)
		}
	}
}
