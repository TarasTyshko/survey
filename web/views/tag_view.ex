defmodule Survey.TagView do
  use Survey.Web, :view
  import Survey.HTML.Helpers
  import Survey.HTML.Survey
  def data() do
    ["Academic", "Accounting ", "Algebra", "Applied", "Art & Design", "Arts", "Atoms, elements, and Compounds ", "Australia", "Biochemistry", "Biology", "Biotechnology", "Business Studies", "BusinessLeadership ", "Calculus", "Career edu", "Career studies", "Cellular Biology ", "Chemical Calculations", "Chemical Reactions", "Chemistry", "Citizenship", "Civics", "Civics (politics)", "Classical Languages", "Computer Science", "Computer studies", "Computing", "Dance", "Design & Technology", "Drama", "Dynamics", "ESL", "Earth Science", "Economics", "English", "Entrepreneurship ", "Environmental Science", "Environmental Science ", "Equity Studies", "Family studies", "Forces", "Functions", "Genetic Processes", "Genetics", "Geography", "Geography ", "Geological Processes", "Geometry", "German", "History", "Homeostasis", "Integrated Arts", "Interdisciplinary Studies", "International Business ", "International Languages", "Kinematics", "Language ", "Languages", "Law", "Learning strategies", "Life Systems", "Linear relations", "Marketing ", "Mathematics", "Measurement", "Measurement ", "Mechanical systems", "Media Design", "Media literacy", "Medical technologies", "Metabolic Processes", "Microbiology", "Molecular Genetics", "Music", "Native languages", "Native studies", "Number", "Oral communication", "Physical Education", "Physics", "Plants: Anatomy, Growth, and Function", "Population Dynamics ", "Probability", "Robotics", "Science", "Social Studies", "Social Studies (Grade 1-6)", "Statistics & Probability", "Technological Education", "Technologies", "UK", "Work Studies", "Work-related Learning", "World studies", "active living", "art", "biology", "chemistry", "civic education", "climate change", "computer programing ", "computer science", "computing", "earth Materials", "economics", "electrical Applications ", "electrochemistry", "energy Conservation", "energy transformations", "english", "evolution", "exploring Matter ", "folksonomic here...)", "french", "geography", "german", "greek", "health living", "history", "latin",  "media arts", "movement Competence: Skills, concepts, and strategies", "music", "nutritional science", "organic Chemistry", "other", "pe", "philosophy", "physics", "politics", "principles & foundations", "reading", "religious studies", "space exploration", "sustainable ecosystems & human activity", "technological education", "tissues, organs, and systems ", "university, college, workplace prep", "visual arts", "visual arts", "world religions", "writing"]
  end

  def likert() do
    "providing alternative explanations or examples when students are confused
responding to difficult questions from your students
adjusting your lessons to differentiate for individual student needs 
using a variety of assessment strategies
monitoring student understanding on an ongoing basis throughout a unit
assessing student understanding at the conclusion of a unit 
providing appropriate challenges for high-achieving students
developing lessons that combine subject matter, technologies, and teaching approaches" |> String.split("\n")
  end
end
