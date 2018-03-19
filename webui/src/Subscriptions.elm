module Subscriptions exposing (subscriptions)

import Time
import Window
import Material.Layout

import Model exposing (Model, Msg(..))

subscriptions : Model -> Sub Msg
subscriptions model = Sub.batch
    [ Time.every Time.minute (always RefreshWanted)
    , Material.Layout.subs Mdl model.mdl
    , Window.resizes WindowResize
    ]
