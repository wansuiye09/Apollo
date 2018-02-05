port module Main.Ports exposing (..)

import Auth0


--PORTS


port initPort : String -> Cmd msg


port openModal : String -> Cmd msg


port closeModal : String -> Cmd msg


port updateTextFields : String -> Cmd msg


port auth0Authorize : Auth0.Options -> Cmd msg


port auth0AuthResult : (Auth0.RawAuthenticationResult -> msg) -> Sub msg


port auth0Logout : () -> Cmd msg
