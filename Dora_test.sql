-- Remember that you MUST USE ACCOUNTADMIN and UTIL_DB.PUBLIC as your context anytime you run DORA checks!!
-- DO NOT EDIT ANYTHING BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT
    'DORA_IS_WORKING' as step,
    (select 223) as actual,
    223 as expected,
    'Dora is working!' as description
);

