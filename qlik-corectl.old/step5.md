This step is about loading data into the app.<br> 

Again [corectl config](https://github.com/qlik-oss/corectl/blob/master/docs/corectl_config.md) will be very useful
<br>

In this step we will continue edit the `corectl.yml`{{open}} file but we also need:  
<br>
**A load script**:   `testscript.qvs`{{open}}
<br> **Some data**: `data/movies.csv `{{open}} 
<br>

**Note** This data is loaded into a docker container, the internal docker container path is /data. If you are curious about the docker file check it out here `cat ../docker-compose.yml`{{execute}} 

## Setup a connection to the data

To be able to load data into your newly created app you will have to:
1. Define what load script you want to use. 
2. Then you will need to expose a connection from the engine container to the load script.

**Exercise: Add the script**

Add a script path in `corectl.yml`{{open}} pointing at  `testscript.qvs`.

<details> <summary>Show solution</summary>
<p> 
<pre class="file" data-filename="corectl.yml" data-target="append">script: testscript.qvs # Path to a script that should be set in the app
</pre>


</p>
</details>  

**Exercise: Expose the connection**  
  Edit the `corectl.yml`{{open}} to open a connection called `testdata` against the folder `/data`.

<details> <summary>Show solution</summary>
<p> 
<pre class="file" data-filename="corectl.yml" data-target="append">
connections: # Connections that should be created in the app
  testdata: # Name of the connection
      connectionstring: /data # Connectionstring (qConnectionString) of the connection. For a folder connector this is an absolute or relative path inside of the engine docker container.
      type: folder # Type of connection

</pre>
</p>
</details>  

<br>

Run `corectl build`{{execute}} to rebuild.
<br>

Yaaay, we loaded some data!!
<br>

## The load script

Before we analyze the loaded data let’s look at the `testscript.qvs`{{open}} we used. If you are familiar with SQL you will see some similarities.
<br>

`
Movies:  
LOAD *
FROM [lib://testdata/movies.csv]
(txt, utf8, embedded labels, delimiter is ',');
`

This script will load * (everything) from `movies.csv` at the exposed connection lib://testdata/. 
<br>

`lib` is a local data path specification (its `web` for webdata, etc).
<br>

The last line in the load script is the config. This will also depend on what data source that is used.
<br> 
<br>

## Load different kinds of file types

Read more about [core data loading](https://github.com/qlik-oss/core-data-loading) to learn about loading different file types. 

## Use corectl analyzing tools 

We have now loaded data into `myapp`. A copy of the data can be seen in `data/movies.csv `{{open}}. corectl comes with a bunch of inbuilt analytics tool we can use on the loaded data.
<br>
If you run `corectl`{{execute}} you will see some helpful analytic tool under the heading `App Analysis Commands` 
<br>

![Analysis](assets/analys.png)

**For example:**
<br>

`corectl fields`{{execute}} - Displays the fields in the app
<br>

`corectl tables`{{execute}} - Displays tables in the app
<br>

`corectl script get`{{execute}} - Display what load script used
<br>

From `corectl fields`{{execute}} we see that the app contains a field called Movie. 
<br>

`corectl values <field name>` - Values in a specific field
<br>

Using `corectl values Movie`{{execute}} will display all the top values of the Movies field.
<br>

**Exercise** <br>
As you can see there are more two more fields in our data tables, can you use `corectl values` to figure out:
 >>How many of the movies that were made in 2009?<<
[ ] One
[*] Four
[ ] Ten

<details> <summary>Show solution</summary>
<p> 
`corectl values Year`{{execute}} 
</p>
</details>  


