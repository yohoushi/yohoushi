## GET /api/yohoushi/graphs
Returns all graphs.

### Example

#### Request
```
GET /api/yohoushi/graphs HTTP/1.1

```

#### Response
```
HTTP/1.1 200
Content-Type: application/json; charset=utf-8

[
  {
    "path": "path/to/graph",
    "uri": "http://www.example.com/api/yohoushi/graphs/path/to/graph"
  }
]
```

## GET /api/yohoushi/graphs/:path
Returns a graph.

### Example

#### Request
```
GET /api/yohoushi/graphs/path/to/graph HTTP/1.1

```

#### Response
```
HTTP/1.1 200
Content-Type: application/json; charset=utf-8

{
  "path": "path/to/graph",
  "description": "test",
  "tag_list": [
    "path",
    "to",
    "graph"
  ],
  "visible": true,
  "created_at": "2014-06-08T08:56:52.000Z",
  "updated_at": "2014-06-08T08:56:52.000Z"
}
```

## PUT /api/yohoushi/graphs/path/to/graph
Updates a graph.

### Example

#### Request
```
PUT /api/yohoushi/graphs/path/to/graph HTTP/1.1


description=test+update&tag_list=a%2Cb%2Cc&visible=false
```

#### Response
```
HTTP/1.1 200
Content-Type: application/json; charset=utf-8

{
  "path": "path/to/graph",
  "description": "test update",
  "tag_list": [
    "a",
    "b",
    "c"
  ],
  "visible": false,
  "created_at": "2014-06-08T08:56:52.000Z",
  "updated_at": "2014-06-08T08:56:52.191Z"
}
```
