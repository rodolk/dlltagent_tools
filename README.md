dlltagent is a tool that let's you find out application issues easily based on network signals.

dlltagent snifs network communication and detects patterns that indicate a problem.

dlltagent will also provide you a focused pcap around the moment of the problem.

You need to have kubectl running and access to the cluster.

Usage:

./monitorPod pod_name [namespace] [interface]

If you don't pass the interface, it considers eth0

If you don't pass a namespace, it uses 'default'.

After calling monitorPod.sh you will have dlltagent_search.yaml ready to apply.

This yaml will install dlltagent in the proper node where the pod to be analyzed is running.


