XMPPBot
=======
Objective-C based XMPP Bot Framework.

Make It Go:
-----------
Two things: 

1) You'll need a Unix fortune formatted file.

2) You'll need a config.json of the form:

<pre>
{
    "anagram":"anagrams.xml",
    "fortune":["fortunes"],
    "login" :
    {
        "username":"[username for XMPP server]",
        "url": "[target XMPP server]"
    }
}
</pre>

Using a Bot:
------------
Bots respond to switches where switches are defined at the start of a line and are prefixed with a forward slash '/'. At the time of this writing the three bots you can invoke would be:
* /? to get a list of the loaded bots
* /fortune to get a unix fortune
* /anagaram to find anagrams for all the words following the /anagram switch

Notice: This project makes use of libstrophe and its dependencies.

Use at your own risk. :)
