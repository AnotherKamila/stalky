module View exposing (view)

import Html                exposing (Html, text)
import List.Extra          as List
import Html.Attributes     as Html
import Material.Scheme     as Scheme
import Material.Color      as Color
import Material.Layout     as Layout
import Material.Footer     as Footer
import Material.Options    as Options exposing (cs, css, div)
import Material.Typography as Typography

import CsvTsdb.TrackView

import Model exposing (Model, Msg(..), Tab(..))

tabs       = [ Track,   View,   Explore ]
tab_titles = ["Track", "View", "Explore"]

view : Model -> Html Msg
view model =
    let
        tab_idx      = tabs |> List.elemIndex model.tab |> Maybe.withDefault -1
        idx2tab idx  = tabs |> List.getAt idx |> Maybe.withDefault NotFound
        tabs_html    = tab_titles |> List.map text
        --tabs_options = [Color.background (Color.color Color.primary Color.S400)]
        tabs_options = [Color.background (Color.primaryDark)]
    in (Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader, Layout.fixedTabs, Layout.waterfall True
        , Layout.selectedTab tab_idx
        , Layout.onSelectTab (idx2tab >> SelectTab)
        ]
        { header = header model
        , drawer = []
        , tabs   = (tabs_html, tabs_options)
        , main   = [text model.err, view_content model, footer]
        }
    --|> Material.Scheme.topWithScheme Color.Teal Color.Red
    ) |> Scheme.topWithScheme Color.Indigo Color.Green

-- HEADER --

header model =
    [ Layout.row
        [ css "transition" "height 0.5s ease-in-out"
        --, Color.background (Color.primaryDark)
        ]
        [ Layout.title [] [text "Stalk Yourself!"]
        , Layout.spacer
        ]
    ]

-- BODY --

view_content : Model -> Html Msg
view_content model =
    let content = case model.tab of
        Track    -> CsvTsdb.TrackView.view model.data
        View     -> text "Not Implemented Yet"
        Explore  -> text "Not Implemented Yet"
        NotFound -> Options.styled Html.h1
            [ cs "mdl-typography--display-4", Typography.center ]
            [ text "404" ]
    in div [ cs "content" ] [ content ]

-- FOOTER --

footer =
    let links = [ ("GitHub",   "https://github.com/AnotherKamila/stalkme")
                , ("Feedback", "https://goo.gl/forms/AlMtCnldYr3frELa2")
                , ("♥ Donate",   "https://liberapay.com/kamila/donate")
                ]
        link (t, h) = Footer.linkItem [ Footer.href h ] [ Footer.html <| text t ]
        links_html = links |> List.map link
    in Footer.mini [ cs "allthethings" ]
        { left  = Footer.left  [] [ Footer.links [] links_html ]
        , right = Footer.right [] []
        }
