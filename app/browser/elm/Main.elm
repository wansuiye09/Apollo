module Main exposing (..)

import Main.Ports exposing (..)
import Html exposing (Html, h1, text)
import Html.Attributes exposing (style)


-- MODEL


type alias Model =
    { flags : Flags }


type alias Flags =
    { apiUrl : String }



-- INIT


init : Flags -> ( Model, Cmd Message )
init flags =
    ( { flags = flags }, initPort "" )



-- VIEW


view : Model -> Html Message
view model =
    -- The inline style is being used for example purposes in order to keep this example simple and
    -- avoid loading additional resources. Use a proper stylesheet when building your own app.
    h1 [ style [ ( "display", "flex" ), ( "justify-content", "center" ) ] ]
        [ text "Hello Elm!" ]



-- MESSAGE


type Message
    = None



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.none



-- MAIN


main : Program Flags Model Message
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
