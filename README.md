
Tomtelizer-server - a christmas hat image service
=================================================

Tomtelize-server will superimpose a christmas hat to any image
sent together with face feature data (i.e image and data sent
from the `Tomtelizer` iPhone application).


Dependencies
------------

 * delayed_job
 * rmagick
 * sqlite3


Starting
--------

        $ ./script/delayed_job start && rails server


Post data format
----------------

/test/functional/images_controller_test.rb

```ruby
assert_difference('Image.count', 1) do
   assert_difference('FaceFeature.count', 2) do
    
     #/images/new
     #post data format: features[][left_eye_x]=123 etc
     post :new, :uploaded => file, :features => [{ :left_eye_x => 12,
                                                   :left_eye_y => 13,
                                                   :right_eye_x => 14,
                                                   :right_eye_y => 15,
                                                   :mouth_x => 20,
                                                   :mouth_y => 30 },
                                                 { :left_eye_x => 12,
                                                   :left_eye_y => 13,
                                                   :right_eye_x => 14,
                                                   :right_eye_y => 15,
                                                   :mouth_x => 20,
                                                   :mouth_y => 30} ]

    
   end
end
```


