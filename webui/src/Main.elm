module Main exposing (main)

import RouteUrl exposing (RouteUrlProgram)

import Model
import Update
import View
import Subscriptions
import Routing

main = RouteUrl.program
    { init              = (Model.init, Update.init)
    , update            = Update.update
    , view              = View.view
    , subscriptions     = Subscriptions.subscriptions
    , delta2url         = Routing.delta2url
    , location2messages = Routing.location2messages
    }
