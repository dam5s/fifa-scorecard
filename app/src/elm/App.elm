module App exposing (main)

import Browser
import Html exposing (Html, div, text)


type alias Flags =
    {}


type alias Model =
    {}


type Msg
    = None


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( {}, Cmd.none )


view : Model -> Html Msg
view model =
    div [] [ text "Oh hai" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
