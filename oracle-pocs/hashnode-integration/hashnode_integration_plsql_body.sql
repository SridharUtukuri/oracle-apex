create or replace PACKAGE BODY portfolio_hashnode_blog AS

  PROCEDURE fetch_blog_json(p_json OUT CLOB) IS
    l_url      VARCHAR2(500) := 'https://gql.hashnode.com/';
    l_payload  CLOB;
    l_response CLOB;
  BEGIN
    l_payload := '{
      "query": "query GetAllPosts {\n  user(username: \"sridharutukuri\") {\n    publications(first: 10) {\n      edges {\n        node {\n          title\n          posts(first: 50) {\n            edges {\n              node {\n                title\n                slug\n                url\n                brief\n                publishedAt\n                coverImage {\n                  url\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n}"
    }';

    apex_web_service.set_request_headers(
      p_name_01  => 'Content-Type',
      p_value_01 => 'application/json'
    );

    l_response := apex_web_service.make_rest_request(
      p_url         => l_url,
      p_http_method => 'POST',
      p_body        => l_payload
    );

    p_json := l_response;
  END fetch_blog_json;


  PROCEDURE render_blog_list IS
  l_json CLOB;
BEGIN
  fetch_blog_json(l_json);

  FOR rec IN (
    SELECT *
    FROM JSON_TABLE(
      l_json,
      '$.data.user.publications.edges[*].node.posts.edges[*].node'
      COLUMNS (
        title         VARCHAR2(500)  PATH '$.title',
        slug          VARCHAR2(500)  PATH '$.slug',
        url           VARCHAR2(1000) PATH '$.url',
        brief         VARCHAR2(4000) PATH '$.brief',
        published_at  VARCHAR2(100)  PATH '$.publishedAt',
        cover_url     VARCHAR2(1000) PATH '$.coverImage.url'
      )
    )
    ORDER BY TO_DATE(SUBSTR(published_at, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') DESC
  ) LOOP

    -- Outer Container
    htp.p('<div style="display:flex; flex-wrap:wrap; margin-bottom:24px; border:1px solid #ddd; border-radius:12px; overflow:hidden; box-shadow:0 2px 6px rgba(0,0,0,0.05); min-height:180px;">');

    -- Left: Cover Image (stretched vertically)
    htp.p('<div style="flex: 0 0 280px; background-color:#f9f9f9; display:flex; align-items:stretch;">');
    IF rec.cover_url IS NOT NULL THEN
      htp.p('<img src="' || rec.cover_url || '" style="width:100%; object-fit:cover;">');
    ELSE
      htp.p('<div style="width:100%; height:180px; background:#eee; display:flex; align-items:center; justify-content:center;">No Cover Photo</div>');
    END IF;
    htp.p('</div>');

    -- Right: Blog Content
    htp.p('<div style="flex: 1; padding: 16px; display:flex; flex-direction:column; justify-content:center;">');
    htp.p('<h2 style="margin-top:0;"><a href="' || rec.url || '" target="_blank" style="text-decoration:none; color:#2563eb;">' || rec.title || '</a></h2>');

    htp.p('<p style="color:#444;">' || rec.brief || '</p>');
    htp.p('<p style="margin-top:8px; color:#666; font-size:0.9em;">📅 ' ||
      TO_CHAR(TO_DATE(SUBSTR(rec.published_at, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS'), 'Month DD, YYYY') || '</p>');
    htp.p('</div>');

    htp.p('</div>');

  END LOOP;
END render_blog_list;


END portfolio_hashnode_blog;
/