Space Truckin'
==============

This is roughly a clone of the old Space Taxi program.
You drive a box truck around in space, making deliveries.

This is written partly so that I have a project to learn Elm,
and partly because I loved Space Taxi so much, I want to play more games like it.


Running
-------

To test, run `elm-reactor` and go to http://localhost:8000/src/main.elm.


TODO
----

* Add landing pads for the truck to land on.
* Add a route for the truck to follow (series of landing pads).
* Add objects for the truck to crash into.
* Consider using a JavaScript 2D game framework.
    * [PhaserJS](https://phaser.io/)
        * See [here](https://github.com/jschomay/little-red-riding-hood/blob/master/top-down/src/index.js) for how to integrate w/ Elm.
    * [PixiJS](http://www.pixijs.com/)
    * [MelonJS](http://melonjs.org/)
    * [Impact](http://impactjs.com/)
* Consider using an Elm physics library.
    * [Boxes and Bubbles](https://github.com/jastice/boxes-and-bubbles/tree/master/examples)
* Add a series of screens.
    * Each will have different landing pads, objects, and routes.
* Customize game-play of each screen.
    * Different gravity possibly.
    * Dynamic objects that are created during game-play.


Credits
-------

Truck image from http://4vector.com/free-vector/5-truck-vector-27323.
