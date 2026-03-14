create or replace PACKAGE portfolio_hashnode_blog AS
  PROCEDURE fetch_blog_json(p_json OUT CLOB);
  PROCEDURE render_blog_list;
END portfolio_hashnode_blog;
/