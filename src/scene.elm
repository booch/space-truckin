module Scene exposing (Model, init, view)

import Screen
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Truck


type alias Model =
    { pads : List Pad
    }

type alias Pad =
    { x: Float
    , y: Float
    }

type alias Msg = {}


init : Model
init =
    { pads = [
            { x = 0.0, y = 0.0 }
        ]
    }

view : Model -> Svg Msg
view model =
    Svg.rect
        [ Svg.Attributes.width (toString (Truck.width * 1.8))
        , Svg.Attributes.height (toString 25)
        , Svg.Attributes.x (toString 400)
        , Svg.Attributes.y (toString (Screen.height - 25))
        , Svg.Attributes.style "fill: green;"
        ]
        []
