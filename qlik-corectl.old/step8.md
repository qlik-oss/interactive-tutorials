To load two or more files, we need to do two things: 
1. We need to setup a connection to each file. 
2. We need to change the load script, so it loads both files.
<br>

**Exercise:** Create a connection that connects both to the URL to the movies info and the folder connection to the /data folder.

<details> <summary>Show solution</summary>
<p> 

<pre class="file" data-filename="corectl.yml" data-target="replace">
engine: localhost:19076 # URL and port to running Qlik Associative Engine instance
app: myapp   # App name that the tool should open a session against.
script: testscript.qvs # Path to a script that should be set in the app
connections: # Connections that should be created in the app
  testdata:
      connectionstring: /data # Connectionstring (qConnectionString) of the connection. For a folder connector this is an absolute or relative path inside of the engine docker container.
      type: folder # Type of connection
  webdata: 
      connectionstring: 'https://gist.githubusercontent.com/carlioth/b86ede12e75b5756c9f34c0d65a22bb3/raw/e733b74c7c1c5494669b36893a31de5427b7b4fc/MovieInfo.csv'
      type: internet 

</p>
</details>

**Exercise:** Create a load script that appends both load files together.

<details> <summary>Show solution</summary>
<p> 

We already have the load scripts for both these files ready so we just merge both script files to one. Let’s append the Movies loadscript to the `testscript.qvs`{{open}}:

<pre class="file" data-filename="testscript.qvs" data-target="append">
Movies:
LOAD *
FROM [lib://testdata/movies.csv]
(txt, utf8, embedded labels, delimiter is ',');
</pre>
</p>
</details>

First, we need to rebuild the app `corectl build`{{execute}}.

Run: `corectl tables`{{execute}}!!

There are now two tables in our app!
<br>

## Associations

Checkout: [catwalk](https://catwalk.core.qlik.com/?engine_url=wss://[[HOST_SUBDOMAIN]]-19076-[[KATACODA_HOST]].environments.katacoda.com/home/engine/Qlik/Sense/Apps/myapp).
<br>

As you can see we now have relation in within our tables. Catwalk will automatically relate fields with the same name which is very powerful when adding a lot of table and when the data system is more complex.
<br>

You can see the associations between tables with: `corectl assoc`{{execute}}


