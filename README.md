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

Notice: This project makes use of libstrophe and its dependencies.

Use at your own risk. :)
