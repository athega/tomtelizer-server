role :web, "tomtelizer.athega.se"                   # Your HTTP server, Apache/etc
role :app, "tomtelizer.athega.se"                   # This may be the same as your `Web` server
role :db,  "tomtelizer.athega.se", :primary => true # This is where Rails migrations will run
