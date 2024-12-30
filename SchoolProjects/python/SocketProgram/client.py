import socket
from threading import Thread

import os

class Client:

#constructor for Client class
    def __init__(self, HOST, PORT):         
        self.socket = socket.socket()           #initialize the socket
        self.socket.connect((HOST, PORT))       #connect socket to the server

        self.talk_to_server()                   

#Starts thread for the client and begins sending messages
    def talk_to_server(self):
        Thread(target = self.receive_message).start()
        self.send_message()

#Send messages to the server
    def send_message(self):
        while True:
            client_input = input("")            #Asks for input from the user of the client
            client_message = client_input       #Makes the client message the client input
            self.socket.send(client_message.encode())   #Send the packet in bytes to the server

#Receives messages from the server
    def receive_message(self):
        while True:
            server_message = self.socket.recv(1024).decode()        #Messages decoded from the server
            if not server_message.strip():                          #Exit if the server message it's not giving
                os._exit(0)
            print("\033[1;31;40m" + server_message + "\033[0m")     #Print out the server message in red bold

if __name__ == '__main__':
    Client('127.0.0.1', 65432)                  #Start client