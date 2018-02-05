module Main.Models exposing (..)

import Main.Ports exposing (auth0Authorize, auth0Logout)
import Auth0
import Authentication


-- MESSAGE


type Msg
    = AuthenticationMsg Authentication.Msg



-- MODEL


initModel : Flags -> Model
initModel flags =
    { quote = ""
    , apiUrl = flags.apiUrl
    , authModel = Authentication.init auth0Authorize auth0Logout flags.auth0User
    }


type alias Model =
    { apiUrl : String
    , quote : String
    , authModel : Authentication.Model
    }


type alias Flags =
    { apiUrl : String
    , auth0User : Maybe Auth0.LoggedInUser
    }
