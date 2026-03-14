
# Display Your Hashnode Blogs in an Oracle APEX Website

As an Oracle APEX developer, I wanted to show my Hashnode blogs directly on my portfolio website built using Oracle APEX.  

In this guide, I explain how I used the **Hashnode GraphQL API** to fetch my blog posts and display them inside an Oracle APEX application.

The same approach can be used by anyone who wants to show their Hashnode articles on a personal website.

---

# Hashnode API Documentation

Hashnode provides a GraphQL API that allows developers to fetch blog data such as posts, publications, and user information.

Official API documentation:  
https://apidocs.hashnode.com/

---

# Step 1: GraphQL Query

The following GraphQL query fetches blog posts from a Hashnode user.

```graphql
query GetAllPosts {
  user(username: "sridharutukuri") {
    publications(first: 10) {
      edges {
        node {
          title
          posts(first: 50) {
            edges {
              node {
                title
                slug
                url
                brief
                publishedAt
                coverImage {
                  url
                }
              }
            }
          }
        }
      }
    }
  }
}
```

You can test this query using the Hashnode GraphQL playground:

https://gql.hashnode.com/

Important:  
Replace `sridharutukuri` with your own Hashnode username.

Example:

```
user(username: "your_hashnode_username")
```

You can also change:

- `publications(first: 10)`
- `posts(first: 50)`

depending on how many posts you want to retrieve.

---

# Step 2: Sample API Response

A typical response from the API looks like this:

```json
{
  "data": {
    "user": {
      "publications": {
        "edges": [
          {
            "node": {
              "title": "sridhar utukuri",
              "posts": {
                "edges": [
                  {
                    "node": {
                      "title": "Hello, World! I’m Sridhar, Oracle APEX Expert",
                      "slug": "sridhar-oracle-apex-expert",
                      "url": "https://sridharutukuri.hashnode.dev/sridhar-oracle-apex-expert",
                      "brief": "Hey there, Hashnode community...",
                      "publishedAt": "2024-11-08T19:48:23.229Z",
                      "coverImage": null
                    }
                  }
                ]
              }
            }
          }
        ]
      }
    }
  }
}
```

---

# Step 3: Convert the Query to cURL

Once the query works in the GraphQL playground, convert it into a **cURL request**.

This request can be tested using Postman.

```bash
curl --location 'https://gql.hashnode.com/' \
--header 'Content-Type: application/json' \
--data '{
  "query": "query GetAllPosts {\n  user(username: \"sridharutukuri\") {\n    publications(first: 10) {\n      edges {\n        node {\n          title\n          posts(first: 50) {\n            edges {\n              node {\n                title\n                slug\n                url\n                brief\n                publishedAt\n                coverImage {\n                  url\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n}"
}'
```

Test the request in Postman to make sure it returns the expected blog data.

---

# Step 4: Convert cURL to PL/SQL

To use this API inside Oracle APEX, I converted the cURL request into a **PL/SQL package**.

The package contains procedures that:

- Call the Hashnode API
- Retrieve the JSON response
- Format the response
- Display blog posts in the APEX UI

Main procedures used:

`fetch_blog_json`  
Fetches blog data from the Hashnode API.

`render_blog_list`  
Formats the response and prepares HTML output to display in the UI.

---

# Step 5: Create an Oracle APEX Page

Next, create a sample Oracle APEX application.

Steps:

1. Create a new APEX application
2. Create a page
3. Add a region
4. Call the PL/SQL procedure `render_blog_list`

![Apex Page](https://github.com/SridharUtukuri/oracle-apex/blob/main/oracle-pocs/hashnode-integration/hashnode_integration_apex_region.png)

After running the application, your Hashnode blog posts will appear in your Oracle APEX portfolio website.

---

My Oracle Apex Portfolio Website:

![My Oracl Apex Website](https://github.com/SridharUtukuri/oracle-apex/blob/main/oracle-pocs/hashnode-integration/hashnode_integration_app_ui.png)

My Hashnode Profile:

![My Hashnode Profile](https://github.com/SridharUtukuri/oracle-apex/blob/main/oracle-pocs/hashnode-integration/hashnode_profile.png)


---

All files used in this example are available here: [View Project Files](https://github.com/SridharUtukuri/oracle-apex/tree/main/oracle-pocs/hashnode-integration)

---

# Conclusion

Using the Hashnode GraphQL API, you can easily integrate your blog posts into an Oracle APEX application.

This approach helps developers display their technical blogs directly on their personal portfolio websites.

---

# Disclaimer

This blog reflects my personal insights and experiences, mainly around Oracle Applications. All opinions are my own and do not represent Oracle or any employer.
