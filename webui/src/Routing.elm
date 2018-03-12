module Routing exposing (url2tab, tab2url, location2messages, delta2url)

import Navigation exposing (Location)
import RouteUrl   exposing (UrlChange)


import Model exposing (Model, Msg(..), Tab(..))

url2tab : Location -> Tab
url2tab url = case url.hash of
    ""         -> Track
    "#"        -> Track
    "#track"   -> Track
    "#view"    -> View
    "#explore" -> Explore
    _          -> NotFound

tab2url : Tab -> String
tab2url tab = case tab of
    Track    -> "#track"
    View     -> "#view"
    Explore  -> "#explore"
    NotFound -> "#something-somewhere-went-terribly-wrong"

location2messages : Location -> List Msg
location2messages url = [SelectTab (url2tab url)]

delta2url : Model -> Model -> Maybe UrlChange
delta2url _ model = Just {entry = RouteUrl.NewEntry, url = tab2url model.tab}
