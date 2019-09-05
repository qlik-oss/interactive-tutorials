
In this step we won't go as much into details since corectl doesn't provide any visualization tools.
<br>
 
Before you can do this step you need to install some dependencies(this can take some time):
`./../installdep.sh`{{execute}} 
`clear`{{execute}}

We will go through a simple example how you could use corectl together with picasso.js to create a simple bar chart. 
<br>

## Picasso.js

[Picasso.js](https://picassojs.com/) is a visualization javascript library to create visualization. It comes with a q-plugging which provides a lot of help when extracting data from a engine-app. So we don't have to use `layout.qHyperCube.qDataPages[0].qMatrix` every time we want to interact with the loaded data. 
<br>

If you want to see more visualizations check out [picasso.js examples](https://picassojs.com/examples.html).

We will need two more files working with picasso.js:

* `index.html`{{open}} - A html file containing a simple container to render our chart in. 

* `touch barchart.js`{{execute}} - The settings from [picasso.js examples](https://picassojs.com/examples.html) bar chart example.
<br>

To create this visualization we will use `picasso.chart()` to render a bar chart. This method have three arguments:
* Data 
* Chart-settings/chart-layout
* A html-element to render the chart in.  

## Load the data

To use the bar chart, we need values for the y-axis and for the t-axis. We can for example to do a bar chart that displays the number of movies made every year. This means we need the Years on the t-axis with the corresponding number of movies each year on the y-axis. We already have all the needed data to accomplish this in `data/movies.csv`{{open}}. Therefore, there is no need to change either the corectl.yml file or the loadscript.
<br>

But we need to do some adjustments in the object. We load the field Year as qDimension and a measurement called Count(Year) into our `corectl-object.json`.
<br>

We can double check that we have values in the `Year` field with: `corectl values Year`{{execute}}
<br>

The object after these changes will look something like this:

`corectl-object.json`{{open}}
<br>

<pre class="file" data-filename="corectl-object.json" data-target="replace">
{
  "qInfo": {
    "qType": "measure",
    "qId": "Barchart"
  },
  "qHyperCubeDef": {
    "qDimensions": [{
      "labels": true,
      "qDef": {
        "qFieldDefs": [
          "Year"
        ],
        "qSortCriterias": [{
          "qSortByAscii": 1
        }]
      }
    }],
    "qMeasures": [{
        "labels": true,
        "qDef": {
          "qLabel": "Count(Year)",
          "qDef": "Count(Year)",
          "autoSort": true
        }
      }

    ],

    "qInitialDataFetch": [{
      "qHeight": 50,
      "qWidth": 10
    }]
  }
}

</pre>

Update the app with `corectl build`{{execute}}.

## Setting up picasso.js

We have prepared a simple `<div>` called container in the `index.html`{{open}} which we will render the Picasso.js chart in.
<br>

Now we need to setup chart settings for our bar chart. We use [picasso barchart example](https://observablehq.com/@miralemd/picasso-js-barchart) as template with some smaller modifications so it fits our data. 
<br>

`barchart.js`{{open}}

<pre class="file" data-filename="barchart.js" data-target="replace">
export const chartSettings = {
    scales: {
        labels: 'true',
        y: {
            data: {
                field: 'Count(Year)'
            },
            invert: true,
            include: [0]
        },
        c: {
            data: {
                field: 'Count(Year)'
            },
            type: 'color'
        },

        t: {
            data: {
                extract: {
                    field: 'Year'
                }
            },
            padding: 0.3
        },
    },
    components: [{
            type: 'axis',
            dock: 'left',
            scale: 'y'
        }, {
            type: 'axis',
            dock: 'bottom',
            scale: 't'
        }, {
            key: 'bars',
            type: 'box',
            data: {
                extract: {
                    field: 'Year',
                    props: {
                        start: 0,
                        end: {
                            field: 'Count(Year)'
                        }
                    }
                }
            },
            settings: {
                major: {
                    scale: 't'
                },
                minor: {
                    scale: 'y'
                },
                box: {
                    fill: {
                        scale: 'c',
                        ref: 'end'
                    }
                }
            }
        },
        {
            type: 'text',
            text: 'Year',
            layout: {
                dock: 'bottom'
            }
        },
        {
            type: 'text',
            text: 'Number of Movies',
            layout: {
                dock: 'left'
            }
        }
    ]
}
</pre>

<br>

## Put everything together

We put this together in the `app.js`{{open}} first we connect to engine and load the data as in previous examples. Then we us `picasso.chart()` to render our bar chart we created.
<br>

Since the visualization will be rendered outside this enviroment you will have to replace the localwebsocket with a katacoda endpoint.
<br>
Replace the code `ws://localhost:19076/app/` with 
`wss://[[HOST_SUBDOMAIN]]-19076-[[KATACODA_HOST]].environments.katacoda.com/app/`

<pre class="file" data-filename="app.js" data-target="replace">
const enigma = require('enigma.js');
import picasso from 'picasso.js';
import 'babel-polyfill';
import picassoQ from 'picasso-plugin-q';
const schema = require('enigma.js/schemas/3.2.json');
import {
    chartSettings
} from './barchart.js';

(async () => {
    try {

        console.log('Creating session app on engine.');
        const session = enigma.create({
            schema,
            url: 'wss://[[HOST_SUBDOMAIN]]-19076-[[KATACODA_HOST]].environments.katacoda.com/app/',
            createSocket: url => new WebSocket(url),
        });
        const qix = await session.open();
        const app = await qix.openDoc('myapp');
        const object = await app.getObject('Barchart');
        const layout = await object.getLayout();

        await picassoPaint(chartSettings, layout)

    } catch (err) {
        console.log('Whoops! An error occurred.', err);
        process.exit(1);
    }
})();

function picassoPaint(settings, layout) {

    picasso.use(picassoQ);

    picasso.chart({
        element: document.querySelector('#container'), // This is the element to render the chart in
        data: [{
            type: 'q',
            key: 'qHyperCube',
            data: layout.qHyperCube,
        }],
        settings,
    });

}
</pre>

<br>

Use `npm run barchart`{{execute}} (might take some time) to create the exampled and view it at:
<br>

[**The bar chart**](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/)

<br>




