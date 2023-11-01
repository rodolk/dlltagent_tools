dlltagent is a tool that let's you find out application issues easily based on network signals.

dlltagent snifs network communication of a pod and detects patterns that indicate a problem.

dlltagent will also provide you a focused pcap around the moment of the problem. These are small pcap files with a limit around 2MB.

You need to have kubectl running and access to the cluster.

Usage:

./monitorPod.sh pod_name [namespace] [interface]

pod_name is the specific pod name

Example:
./monitorPod.sh bird-front-569df4d45f-r7csn

If you don't pass the interface, it considers eth0

If you don't pass a namespace, it uses 'default'.

After calling monitorPod.sh you will have dlltagent_search.yaml ready to apply.

kubectl apply -f dlltagent_search.yaml

This yaml will install dlltagent in the proper node where the pod to be analyzed is running.

Please do not touch dlltagent_pod.yaml, this is the basis for the dlltagent_search.yaml

If you need to search any specific text, you need to modify the env variable SEARCH_HTTP_HEADER in dlltagent_search,
now with value 'X-Pepe'. dlltagent will detect the corresponding message and will track that connection and dump it to a pcap file.


How is this useful?
1. You can detect an SSL issue with details of the exact problem. For example, if the connection cannot be established because of an invalid certificate, it will give you all details in file netevents: which side didn't accept the certificate during the SSL handshake and the specific SSL error. It will also write a pcap file that you can see with Wireshark.
2. You can detect a variety of connectivity issues. For example, when a process, or application, in a POD cannot connect to a service, or a pod, or an external service, because there is a port closed, it will detect the specific pattern in the network and will write the proper code in the netevents file. In this case a pcap file is not necessary.
3. You can detect a connection where the first GET or POST message contains a special text in the HTTP headers. Then the agent will follow that connection and will write a pcap file with the messages exchanged during around the next 30 secs. The pcap will have connection establishment messages and latest messages exchanged. It may have a gap because it uses a circular buffer.
4. You will have the pcap file of the connection and messages that had an issue.
5. The file end_flows will give you network performance information about ended connections: IPs and ports, latency measured with TCP handshake, time-to-complete TLS handsake, connection begin time, connection end time, protocol, and how the connection ended (with a RESET, with a TLS alert, with a normal FIN).

It has some known limitations:
-This manifest lets you use a docker image that will monitor only one virtual interface in one node. You still can create a pod per virtual interface.
-If the pod is killed, the virtual interface goes down and dlltagent cannot handle that event yet
-It will not provide information about TCP connections already established when the agent began to run. It needs to detect the TCP handshake to consider it a valid connection.
-At very high throughput, it can lose packets.

This code is property of Wayaga LLC
Please let us know if you are using it and send your feedback to rodolfo.kohn@wayaga.com






