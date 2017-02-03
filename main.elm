module Main exposing (..)

import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, millisecond)
import Keyboard.Extra as Keyboard
import Truck
import Screen
import Scene


type alias Model =
    { scene: Scene.Model
    , truck : Truck.Model
    , time : Time
    , keyboard : Keyboard.Model
    }

type Msg =
    Tick Time
    | KeyboardMsg Keyboard.Msg
    | TruckMsg Truck.Msg
    | SceneMsg {}


main : Program Never Model Msg
main =
    Html.program { init = init, update = update, view = view, subscriptions = subscriptions }


init : ( Model, Cmd Msg )
init =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.init
    in
        ( { scene = Scene.init, truck = Truck.init, time = 0, keyboard = keyboardModel }, Cmd.map KeyboardMsg keyboardCmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            let
                ( keyboardModel, keyboardCmd ) =
                    Keyboard.update keyMsg model.keyboard
            in
                ( { model | keyboard = keyboardModel }
                , Cmd.map KeyboardMsg keyboardCmd
                )
        Tick newTime ->
            let
                arrows =
                    Keyboard.arrows model.keyboard
                truck =
                    model.truck
                        |> Truck.thrust arrows
                        |> Truck.gravity
                        |> Truck.move
            in
                ( { model | time = newTime, truck = truck }, Cmd.none )
        TruckMsg msg ->
            ( model, Cmd.none )
        SceneMsg msg ->
            ( model, Cmd.none )


view : Model -> Svg Msg
view model =
    Svg.svg [ version "1.1", x "0", y "0", (viewBox ("0 0 " ++ (toString Screen.width) ++ " " ++ (toString Screen.height))), Svg.Attributes.style "background: black;" ]
        [ Html.map SceneMsg (Scene.view model.scene)
        , Html.map TruckMsg (Truck.view model.truck) ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyboardMsg Keyboard.subscriptions
        , Time.every (8 * millisecond) Tick
        ]
