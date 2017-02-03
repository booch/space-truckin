module Truck exposing (Model, Msg, init, update, thrust, turn, gravity, move, view, width, height)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Screen


height : Float
height =
    Screen.height / 12

width : Float
width =
    height * 2


type alias Model =
    { width : Float
    , height : Float
    , location : Location
    , direction : Direction
    , velocity : Vector
    , acceleration : Vector
    }

type alias Location =
    { x : Float
    , y : Float
    }

type Direction =
    Left
    | Right

type alias Vector =
    { x : Float
    , y : Float
    }

type alias Arrows =
    { x : Int
    , y : Int
    }

type Msg =
    Turn Direction
    | Move Vector


init : Model
init =
    { width = width
    , height = height
    , location = { x = (Screen.width - width) / 2, y = (Screen.height - height) / 2 }
    , direction = Right
    , velocity = { x = 0, y = 0 }
    , acceleration = { x = 0, y = 0 }
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Move vector ->
            { model | location = { x = model.location.x + vector.x, y = model.location.y + vector.y } }
        Turn direction ->
            { model | direction = direction }


thrust : Arrows -> Model -> Model
thrust arrows model =
    accelerate { x = (0.0001 * (toFloat arrows.x)), y = (-0.0001 * (toFloat arrows.y)) } model
        |> turn arrows


turn : Arrows -> Model -> Model
turn arrows model =
    case arrows.x of
        1 ->
            { model | direction = Right }
        (-1) ->
            { model | direction = Left }
        _ ->
            model


gravity : Model -> Model
gravity model =
    accelerate { x = 0.0, y = 0.00004 } model


accelerate : Vector -> Model -> Model
accelerate accelerationVector model =
    { model | acceleration = {
            x = (clamp -0.01 0.01 (model.acceleration.x + accelerationVector.x)),
            y = (clamp -0.01 0.01 (model.acceleration.y + accelerationVector.y)) },
        velocity = {
            -- Note that we're using the *old* acceleration here.
            x = (clamp -0.8 0.8 model.velocity.x + model.acceleration.x),
            y = (clamp -0.8 0.8 model.velocity.y + model.acceleration.y) }
    }


move : Model -> Model
move model =
    { model | location = { x = (clamp 0 (Screen.width - model.width) model.location.x + model.velocity.x),
                           y = (clamp 0 (Screen.height - model.height) model.location.y + model.velocity.y) } }


view : Model -> Svg Msg
view model =
    image
        [ Svg.Attributes.xlinkHref "images/truck.svg"
        , Svg.Attributes.height (toString model.height)
        , Svg.Attributes.width (toString model.width)
        , Svg.Attributes.x (toString (truckX model))
        , Svg.Attributes.y (toString model.location.y)
        , flipTruck model
        ]
        []

-- SVG transform to flip the truck left-to-right, if necessary.
flipTruck : Model -> Attribute Msg
flipTruck model =
    case model.direction of
        Left ->
            Svg.Attributes.transform ""
        Right ->
            Svg.Attributes.transform ("translate(" ++ (toString Screen.width) ++ ",0) scale(-1,1)")

-- The SVG transform to flip the truck also messes with its x axis, so account for that.
truckX : Model -> Float
truckX model =
    case model.direction of
        Left ->
            model.location.x
        Right ->
            Screen.width - model.width - model.location.x
