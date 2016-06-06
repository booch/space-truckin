-- Only commenting this out because it messes up Atom's code highlighting (and it's not strictly needed).
-- module Main exposing (..)


import Html exposing (Html)
import Html.App as App
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, millisecond)


type alias Model =
    { truck : Truck
    , time : Time
    }

type alias Truck =
    { x : Float
    , y : Float
    , direction: Direction
    }

type Direction =
    Left | Right

type Msg =
    Tick Time


screenWidth : Float
screenWidth =
    2000

screenHeight : Float
screenHeight =
    1000

truckHeight : Float
truckHeight =
    screenHeight / 12

truckWidth : Float
truckWidth =
    truckHeight * 2


main : Program Never
main =
    App.program { init = init, update = update, view = view, subscriptions = subscriptions }


init : ( Model, Cmd Msg )
init =
    ( { truck = initialTruck, time = 0 }, Cmd.none )


initialTruck : Truck
initialTruck =
    { x = ((screenWidth - truckWidth) / 2)
    , y = ((screenHeight - truckHeight) / 2)
    , direction = Right
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            let truck = model.truck in
                ( { model | time = newTime, truck = { truck | x = model.truck.x + 1 } }, Cmd.none )


view : Model -> Html Msg
view model =
    Svg.svg [ version "1.1", x "0", y "0", (viewBox ("0 0 " ++ (toString screenWidth) ++ " " ++ (toString screenHeight))), Svg.Attributes.style "background: black;" ]
        [ truckImage model.truck ]


truckImage: Truck -> Svg Msg
truckImage truck =
    image [ xlinkHref "truck.svg"
          , height (toString truckHeight)
          , width (toString truckWidth)
          , x (toString (truckX truck))
          , y (toString truck.y)
          , flipTruck truck
          ] []


-- SVG transform to flip the truck left-to-right, if necessary.
flipTruck: Truck -> Attribute Msg
flipTruck truck =
    case truck.direction of
        Left -> transform ""
        Right -> transform ("translate(" ++ (toString screenWidth) ++ ",0) scale(-1,1)")


-- The SVG transform to flip the truck also messes with its x axis, so account for that.
truckX: Truck -> Float
truckX truck =
    case truck.direction of
        Left -> truck.x
        Right -> screenWidth - truckWidth - truck.x


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (8 * millisecond) Tick
