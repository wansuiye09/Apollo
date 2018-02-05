module Main exposing (..)

import Main.Ports exposing (..)
import Main.Models exposing (..)
import Authentication
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, initPort "" )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "jumbotron text-center" ]
            [ div []
                (case Authentication.tryGetUserProfile model.authModel of
                    Nothing ->
                        [ p [] [ text "Please log in" ] ]

                    Just user ->
                        [ p [] [ text ("Hello, " ++ user.email ++ "!") ] ]
                )
            , p []
                [ button
                    [ class "btn btn-primary"
                    , onClick
                        (AuthenticationMsg
                            (if Authentication.isLoggedIn model.authModel then
                                Authentication.LogOut
                             else
                                Authentication.ShowLogIn
                            )
                        )
                    ]
                    [ text
                        (if Authentication.isLoggedIn model.authModel then
                            "Log Out"
                         else
                            "Log In"
                        )
                    ]
                ]
            ]
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthenticationMsg authMsg ->
            let
                ( authModel, cmd ) =
                    Authentication.update authMsg model.authModel
            in
                ( { model | authModel = authModel }, Cmd.map AuthenticationMsg cmd )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    auth0AuthResult (Authentication.handleAuthResult >> AuthenticationMsg)



-- MAIN


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
