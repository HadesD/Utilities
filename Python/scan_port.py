# This script runs on Python 3
import socket, threading

def TCP_connect(ip, port_number, delay, output):
    TCPsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    TCPsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    TCPsock.settimeout(delay)
    try:
        TCPsock.connect((ip, port_number))
        output[port_number] = 'Listening'
    except:
        output[port_number] = ''

MAX_THREAD = 1021

def scan_ports(host_ip, delay):

    threads = []        # To run TCP_connect concurrently
    output = {}         # For printing purposes

    PORT_FROM = 10000

    PORT_TO = PORT_FROM + MAX_THREAD

    # Spawning threads to scan ports
    for i in range(PORT_FROM, PORT_TO):
        t = threading.Thread(target=TCP_connect, args=(host_ip, i, delay, output))
        threads.append(t)

    # Starting threads
    for i in range(MAX_THREAD):
        threads[i].start()

    # Locking the script until all threads complete
    for i in range(MAX_THREAD):
        threads[i].join()

    # Printing listening ports from small to large
    for i in range(MAX_THREAD):
        if output[i+PORT_FROM] == 'Listening':
            print(str(i+PORT_FROM) + ': ' + output[i+PORT_FROM])

def main():
    host_ip = raw_input("Enter host IP: ")
    delay = int(input("How many seconds the socket is going to wait until timeout: "))
    scan_ports(host_ip, delay)

if __name__ == "__main__":
    main()
