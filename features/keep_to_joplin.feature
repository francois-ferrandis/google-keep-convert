Feature: Google Keep Note to Joplin
  Let's go!

  Scenario: A basic note
    Given this Google Keep note
      | title | text_content | timestamp |
      | Remember to learn Cucumber | It looks pretty good for documentation | 2020-04-02 23:20:00 |
    When I convert it to Joplin
    Then the Joplin note should have attributes
      | title | body | updated_time | user_created_time | user_updated_time |
      | Remember to learn Cucumber | It looks pretty good for documentation | 1585869600000 | 1585869600000 | 1585869600000 |
