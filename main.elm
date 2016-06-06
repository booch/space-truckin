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
    }

type Msg
    = Tick Time


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
        [ image
            [ (xlinkHref "truck.svg")
            , height (toString truckHeight)
            , width (toString truckWidth)
            , x (toString model.truck.x)
            , y (toString model.truck.y)
            ]
            []
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (8 * millisecond) Tick
