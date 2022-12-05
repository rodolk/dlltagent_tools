dlltagent is a tool that let's you find out application issues easily based on network signals.

dlltagent snifs network communication of a pod and detects patterns that indicate a problem.

dlltagent will also provide you a focused pcap around the moment of the problem.

You need to have kubectl running and access to the cluster.

Usage:

./monitorPod.sh pod_name [namespace] [interface]

If you don't pass the interface, it considers eth0

If you don't pass a namespace, it uses 'default'.

After calling monitorPod.sh you will have dlltagent_search.yaml ready to apply.

This yaml will installs dlltagent in the proper node where the pod to be analyzed is running.


How is this useful?
1.You can detect SSL issues very easily
2. You can detect connectivity issues
3. You can detect a connection where the first GET or POST message contains a special text in the HTTP headers.
4. You will have the pcap file of the connection and messages that had an issue.


This code is property of Wayaga LLC
You shouldn't use it without authorization of Wayaga LLC
To use it please contact rodolfo.kohn@wayaga.com for authorization




