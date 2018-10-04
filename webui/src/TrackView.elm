module TrackView exposing (view)

import Date.Extra         as Date
import List.Extra         as List
import Html               exposing (Html, text)
import Html.Events        exposing (keyCode)
import Material
import Material.Button    as Button
import Material.Card      as Card
import Material.Chip      as Chip
import Material.Color     as Color
import Material.Elevation as Elevation
import Material.Icon      as Icon
import Material.Options   as Options exposing (cs, css, div)
import Material.Slider    as Slider
import Material.Table     as Table
import Material.Textfield as Textfield

import CsvTsdb.Model exposing (Record)
import Json.Decode as Json

import Model exposing (Model, Msg(..))

view : Model -> Html Msg
view model = [input model, recents model.data] |> div [ cs "track-container" ]

input : Model -> Html Msg
input model =
    let chip t = Chip.button [ Options.onClick (DataInput (t++" "))
                             , Color.background (Color.color Color.Green Color.S100)
                             ] [ Chip.content [] [ text t ] ]
    in Card.view
        [ cs "full-width"
        , Color.background (Color.color Color.Indigo Color.S50)
        , Elevation.e2
        ]
        [ Card.text [] (
            [ Textfield.render Mdl [1,0] model.mdl
                [ Textfield.label "your label (space) number"
                , Textfield.value model.data_input
                , Options.onInput DataInput -- TODO handle enter key
                , onEnter DataSubmit
                ] []
            , Button.render Mdl [1,1] model.mdl
                [ Button.icon, Button.ripple, Button.colored
                , Options.onClick DataSubmit
                ]
                [ Icon.i "send" ]
            , div [ css "margin-left" "-3px"] (model.recent_labels |> List.map chip)
            , Slider.view
                [ Slider.value model.slider_input
                , Slider.max 10
                , Slider.min 0
                , Slider.onChange SliderInput
                ]
            ]

        )
        --, Card.actions
        --    [ css "vertical-align" "center", css "text-align" "right"
        --    , Color.text Color.primary ]
        --    [ Button.render Mdl [1,1] model.mdl
        --        [ Button.icon, Button.ripple ]
        --        [ Icon.i "send" ]
        --    ]
        ]

recents : List Record -> Html msg
recents records = Table.table
    [ cs "full-width", Elevation.e2 ]
    [ Table.tbody []
        (records |> List.reverse |> List.map (\record ->
            Table.tr []
                [ Table.td [] [ text (view_date record.date) ]
                , Table.td [] [ text record.label ]
                , Table.td [ Table.numeric ] [ text (toString record.value) ]
                ]
            )
        )
    ]

view_date = Date.toFormattedString "EEE MMM d, H:mm"

-- onEnter helper
onEnter msg =
    Options.on "keydown" (Json.map (enterKey msg) keyCode)

enterKey : Msg -> Int -> Msg
enterKey msg int = 
  if int == 13
  then msg
  else NoOp
    