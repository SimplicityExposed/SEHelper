Also, I would suggest that you increase the cluster log size to 300 MB by running the command: c:\>cluster log /Size:300 from admin command prompt on any single node of the cluster. Also, make sure to copy the cluster.log from the location C:\Windows\Cluster\Reports folder to any different location on each node soon after the failure to avoid the logs being over-written.

 

Please refer the blog for more details on how cluster logs are generated and reasons why they can be over-written: https://blogs.technet.microsoft.com/askcore/2010/04/13/understanding-the-cluster-debug-log-in-2008/ 
