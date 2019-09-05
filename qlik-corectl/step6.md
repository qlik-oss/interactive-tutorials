After you have created the initial load script, chances are that you experience data modeling problems. In such cases, you may need help finding out how the data is associated and how interactions with the data impacts the model.

Catwalk provides you with a view of all your tables, fields, their associations as well as information about the data within.

When **running corectl locally on your machine** you can use `corectl catwalk`{{execute}} to run catwalk in a browser. 
<br>

Since this katacoda environment has no inbuilt browser you will have to manually enter the app [websocket url](https://catwalk.core.qlik.com/?engine_url=). If you are running a engine container on your local machine the web socket will be `ws://localhost:19076` depending on what port you use.

We have configured the web socket URL for this example:
<br>

 [Catwalk for this example!!!](https://catwalk.core.qlik.com/?engine_url=wss://[[HOST_SUBDOMAIN]]-19076-[[KATACODA_HOST]].environments.katacoda.com/home/engine/Qlik/Sense/Apps/myapp)
<br>

However, we loaded just a small .csv file into our app therefore catwalk won’t display a lot. But when the data structures become bigger and more complex catwalk can be a useful tool.
<br>

If you are curious about how catwalk can be utilize with more complex data take a look at the [catwalk weather data example](https://catwalk.core.qlik.com/?engine_url=wss://apps.core.qlik.com/app/doc/01775889-c700-413f-9b0e-6ba1837c52b0/).


