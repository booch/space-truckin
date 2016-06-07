module Truck exposing (Model, Msg, init, update, move, turn, view)

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


move : Vector -> Model -> Model
move vector model =
    { model | location = { x = model.location.x + vector.x, y = model.location.y + vector.y } }


turn : Int -> Model -> Model
turn xDirection model =
    case xDirection of
        1 ->
            { model | direction = Right }
        (-1) ->
            { model | direction = Left }
        _ ->
            model


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
