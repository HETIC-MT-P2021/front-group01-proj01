module Pages.Categories exposing (view, Msg, update, init, Model)

import Html exposing (Html, h1, map, text, div, p, table, thead, tbody, tr, td, th, a, button, span, input)
import Html.Attributes exposing (class, href, src, type_, placeholder, value)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)

import Header
import Footer

type alias Model =
    { header: Header.Model
    , footer: Footer.Model
    , listCategory: List Category
    , error: Maybe String
    , createForm: CreateForm
    , updateForm: UpdateForm
    , deleteForm: DeleteForm
    }

type alias Category = 
    { id: Int
    , name: String
    , description: String
    , createdAt: String
    , updatedAt: String
    }

createForm = 
    { name = ""
    , description = ""
    }

updateForm = 
    { categoryName = ""
    , newName = ""
    , newDesc = ""
    }

deleteForm = ""

type alias CreateForm = 
    { name: String
    , description: String
    }

type alias UpdateForm = 
    { categoryName: String
    , newName: String
    , newDesc: String
    }

type alias DeleteForm = String

init : ( Model, Cmd Msg )
init =
    ( { header = Header.init
      , footer = Footer.init
      , listCategory = []
      , error = Nothing
      , createForm = createForm
      , updateForm = updateForm
      , deleteForm = deleteForm
      }, getCategories )

type Msg 
    = HeaderMsg Header.Msg
    | FooterMsg Footer.Msg
    | GetAllCategories
    | GotItems (Result Http.Error (List Category))
    | Name String
    | Description String
    | UpdateCategory String
    | NewName String
    | NewDescription String
    | DeleteCategory String

getCategories : Cmd Msg
getCategories = 
    Http.get
    { url = "http://localhost:8080/categories"
    , expect = Http.expectJson GotItems (Decode.list decodeCategory)
    }

decodeCategory : Decoder Category
decodeCategory =
    Decode.map5 Category
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "createdAt" Decode.string)
        (Decode.field "updatedAt" Decode.string)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
    HeaderMsg headerMsg ->
      ( { model | header = Header.update headerMsg model.header }, Cmd.none )

    FooterMsg footerMsg ->
      ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )

    GetAllCategories ->
        (model, getCategories)

    GotItems (Ok categories) ->
        ( { model | error = Nothing, listCategory = categories }, Cmd.none )

    GotItems (Err err) ->
        ( { model | error = Just <| errorToString err, listCategory = [] }, Cmd.none )

    Name name ->
        let
            oldForm = model.createForm
            newForm = 
                { oldForm | name = name }
        in
        ( { model | createForm = newForm }, Cmd.none )

    Description desc ->
      let
            oldForm = model.createForm
            newForm = 
                { oldForm | description = desc }
        in
        ( { model | createForm = newForm }, Cmd.none )

    UpdateCategory category ->
        let
            oldForm = model.updateForm
            newForm = 
                { oldForm | categoryName = category }
        in
        ( { model | updateForm = newForm }, Cmd.none )

    NewName name ->
        let
            oldForm = model.updateForm
            newForm = 
                { oldForm | newName = name }
        in
        ( { model | updateForm = newForm }, Cmd.none )

    NewDescription desc -> 
        let
            oldForm = model.updateForm
            newForm = 
                { oldForm | newDesc = desc }
        in
        ( { model | updateForm = newForm }, Cmd.none )

    DeleteCategory name ->
        ( { model | deleteForm = name }, Cmd.none)

errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Bad url: " ++ url

        Timeout ->
            "Request timed out."

        NetworkError ->
            "Network error. Are you online?"

        BadStatus status_code ->
            "HTTP error " ++ String.fromInt status_code

        BadBody body ->
            "Unable to parse response body: " ++ body

renderCategory : Category -> Html msg
renderCategory category =
    let
        categoryUrl = "/category/" ++ String.fromInt category.id
    in
        tr[]
        [
            td[] [text (String.fromInt category.id)],
            td[] [text category.name],
            td[] [text category.description],
            td[] [text category.updatedAt],
            td[] [a [href categoryUrl][text "Voir"]]
        ]

renderCategories : List Category -> Html msg
renderCategories categories =
    let 
        category = List.map renderCategory categories
    in
        table [] 
        [
            thead[] 
            [
                tr []
                [
                    th [] [text "Identifiants"],
                    th [] [text "Nom"],
                    th [] [text "Description"],
                    th [] [text "Dernière MAJ"]
                ]
            ],
            tbody [] category
        ]

view : Model -> Html Msg
view model =
    div[] [
        map HeaderMsg (Header.view model.header)
        , div[class "content"]
            [
                div []
                    [ 
                        h1 [] [ text "Page des catégories" ]
                        ,p [] [ text "Sur cette page seront listés les catégories"] 
                        , div [class "categories"]
                        [
                            renderCategories model.listCategory
                        ]
                        ,button [ class "orange-btn", onClick GetAllCategories ]
                            [ text "Actualiser les catégories" ]
                    ]
            ]
             , div [class "form"]
            [
                p [] [text "Nouvelle Catégorie"]
                , div [class "form-content"]
                    [ div [] [ text "Nom de la catégorie" ]
                    , viewInput "text" "Nom" model.createForm.name Name
                    , div [] [ text "Description" ]
                    , viewInput "text" "Description" model.createForm.description Description
                    , button [class "orange-btn"] [ text "Poster la catégorie" ]
                    ]
            ]
            , div [class "form"]
            [
                p [] [text "Modifier une Catégorie"]
                , div [class "form-content"]
                    [ div [] [ text "Nom de la catégorie" ]
                    , viewInput "text" "Nom" model.createForm.name Name
                    , div [] [ text "Nouveau nom" ]
                    , viewInput "text" "Description" model.createForm.description Description
                    , div [] [ text "Nouvelle description" ]
                    , viewInput "text" "Description" model.createForm.description Description
                    , button [class "orange-btn"] [ text "Modifier la catégorie" ]
                    ]
            ]
            , div [class "form"]
            [
                p [] [text "Supprimer une catégorie"]
                , div [class "form-content"]
                    [ div [] [ text "Nom de la catégorie" ]
                    , viewInput "text" "Nom" model.createForm.name Name
                    , button [class "orange-btn"] [ text "Supprimer la catégorie" ]
                    ]
            ]
        , map FooterMsg (Footer.view model.footer)
    ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []
    