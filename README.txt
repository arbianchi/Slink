To get list of saved bookmarks:
  Request:
GET "/link" do
HEADER: "Authorization: username"

    Response:
  BODY JSON [{BookmarkObject1
      title: "title"
      description: "description"
      url: "url"
      created_by: "username"
      created_at: timestamp

    },
    {BookmarkObject2
      title: "title"
      description: "description"
      url: "url"
      created_by: "username"
      created_at: timestamp
      }]

    status: (200, 401, 403, etc...)


To get list of recommended bookmarks:

Request:
GET "/link/recommendation" do
HEADER: "Authorization: username"

Response:
BODY JSON [{BookmarkObject1
    title: "title"
    description: "description"
    url: "url"
    created_by: "username"
    posted_to: "otherusername"
    created_at: timestamp

  },
  {BookmarkObject2
    title: "title"
    description: "description"
    url: "url"
    created_by: "username"
    created_at: timestamp
    }]

  Status: (200, 401, 403, etc...)


  To save a bookmark:

    Request:
  POST "/link" do
  HEADER: "Authorization: username"
  BODY: {
    title: "link to save"
    description: "description"
    url: "url"
  }

    Response:
  Status: (200, 401, 403, etc...)
  JSON BODY: "Save was un/successful!"


To recommend a bookmark:
  Request:
POST "link/recommendation" do
Header: "Authorization: username"
BODY: {
  title: "link to recommend"
  posted_at: "user receiving recommendation"
}

  Response:
Status: (200, 401, 403, etc...)
JSON Body "Success/Failure!"

DELETE "/link" do
Header: "Authorization: username"
BODY: {
  title: "link to delete"
}

  Response:
Status
Status: (200, 401, 403, etc...)
JSON Body "Link deleted!" or 'error'
