curl --location 'https://gql.hashnode.com/' \
--header 'Content-Type: application/json' \
--data '{
  "query": "query GetAllPosts {\n  user(username: \"sridharutukuri\") {\n    publications(first: 10) {\n      edges {\n        node {\n          title\n          posts(first: 50) {\n            edges {\n              node {\n                title\n                slug\n                url\n                brief\n                publishedAt\n                coverImage {\n                  url\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n}"
}'
