var locked = false;

function showImage(path){
  if (locked) return;
  var target = $('body div#target');
  if(target){
    locked = true;
    var _im;
    target.fadeOut( 200,
        function(){
          _im =$("<img>");
          _im.bind("load",
              function() { 
                $(target).fadeIn(500, function(){
                  locked = false;
                });
              }
          );
          _im.attr('src', path);
          $('body div#target').html(_im);

          $.ajax({
            method: 'get',
            url:    '/images/metadata',
            data:   'path='+path,
            success: function(data){
              var imageMap = $('<map name="hat-map"/>');
              
              var features = data["face_features"];
              jQuery.each(features, function(i, val) {
                var area = $('<area shape="poly" href="/face_features/show?id=' + val['id'] + '"/>');
                area.attr('coords', val['hat_box_top_left_x'] + ", " +
                                    (data['height'] - val['hat_box_top_left_y']) + ", " +
                                    val['hat_box_top_right_x'] + ", " +
                                    (data['height'] - val['hat_box_top_right_y']) + ", " +
                                    val['hat_box_bottom_right_x'] + ", " +
                                    (data['height'] - val['hat_box_bottom_right_y']) + ", " +
                                    val['hat_box_bottom_left_x'] + ", " +
                                    (data['height'] - val['hat_box_bottom_left_y']));
                imageMap.append($(area));
              });

              $('body div#target').append(imageMap);
              _im.attr("usemap", "#hat-map");
            }
          });
        }
    );
  }
}

function updateImages()
{
  $.ajax({
    method: 'get',
    url : '/images/update_images',
    success: function (data) {
      $('#images').html(data);
      updateWidth();
    }
  });
}

function updateWidth(){
  var total = 0;
  $('div#images img').each(function(i,e){
    total += $(e).width;
  });
  $('div#images').width(total);
}

function startUpdatingImages(){
  currentInterval = setInterval(function(){ updateImages(); }, 5000);
}

