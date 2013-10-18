<!--
 Dan Robinson
 0700662
-->
<html>
<head>	
	<title>Networking</title>
	<link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="/css/site.css">
	<script src="/js/jquery-1.10.2.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function(){
			/*$('#mainButton').popover();*/
			$('#mainButton').click(function(){
				rotateDiv('#rotatingDiv');
			});

			if ($('#messageBar').length > 0){
				// set timeout to hide message
				var messageTimeout = window.setTimeout(function(){hideMessage()}, 2000);
				
				// Remove message so that it doesn't show the next time the page is loaded		
				removeMessage();
			}

			/* Add User */
			$('#addUserForm').on("submit", function(event){
				var name = $('#addUserForm input[name="userid"]').val();
				var image = $('#addUserForm input[name="image"]').val();
				
				addUser(name, image);				
				return false;
			});

			$('#editUserForm').on("submit", function(event){
				/* Delete old user and then add new user with updated fields */
				$.ajax({
					type: "DELETE",
					url: '/users/' + $('#editUserForm').find('.oldName').html(),
					error: function(data){
						console.log("User delete failed " + data);
					},
					success: function(data){
						updateUser($('#editUserModal').find('input[name="userid"]').val(),$('#editUserModal').find('input[name="image"]').val());
					}
				});

				return false;
			});
            	});

		function postMessage(message){
			$.ajax({
				type: "POST",
				url: '/message/' + message,
				error: function(data) {
					console.log("message post failed " + data);
				}
			});
		}

		function removeMessage(){
			$.ajax({
				type: "DELETE",
				url: '/message/xxx',
				error: function(data){
					console.log("message delete failed " + data);
				}
			});
		}

		function addUser(name, img){
			$.ajax({
			    type: "POST",
			    url: '/users/' + name,
			    data: { image: img },
			    success: function(data) {
				postMessage(data);
				window.location.reload();
			    },
			    	error: function(data) {           // Stuff to run on error
				   alert('ERROR');
			       }
			 })
		}
		function editUser(uname){
			$.ajax({
				type: "GET",
				url: '/users/' + uname,
				error: function(data){
					console.log("User Edit failed " + data)
				},
				success: function(data){
					var jsonData = $.parseJSON(data);
					var userid = jsonData.userid;
					var image = jsonData.image;
			
					$('#editUserModal').find('.oldName').html(userid);
					$('#editUserModal').find('input[name="userid"]').val(userid);
					$('#editUserModal').find('input[name="image"]').val(image);
					$('#editUserModal').modal();
				}
			});
						
		}
		function updateUser(uname, image){
			$.ajax({
			    type: "POST",
			    url: '/users/' + uname,
			    data: 'image=' + encodeURIComponent(image),
			    success: function(data) {
				postMessage(data);
				window.location.reload();
			    },
			    	error: function(data) {           // Stuff to run on error
				   alert('ERROR');
			       }
			 });
		}
		function deleteUser(uname){
			$.ajax({
				type: "DELETE",
				url: '/users/' + character,
				error: function(data){
					console.log("Character delete failed " + data);
				},
				success: function(data){
					postMessage(data);
					window.location.reload();
				}
			});
		}
		function hideMessage(){
			$('#messageBar').slideUp();
		}
		function rotateDiv(toRotate){
			var el = $('#rotatingDiv');
			el.animate({'z-index': el.css('z-index')}, {duration: 1000, queue:false, step:function(now,fx){
                		tmpval = Math.round(fx.pos*360)%360;
               			el.css({
                    			'transform': 'rotate('+tmpval+'deg)',
                    			'-moz-transform':'rotate('+tmpval+'deg)',
                  	  		'-webkit-transform': 'rotate('+tmpval+'deg)'
                		})	
			}})
			return el;
		}

		function checkUser(){
			// Get user selected
			var user  = $('#userSelector').find('.active img').attr('data-name');
			$('#userSelectorInput').val(user);
					
		}
	</script>
</head>
<body>
	<div class="pageContent">
		<div id="mainMenu">
			<ul class="nav nav-pills">
 				<li>
    					<a href="/">Home</a>
  				</li>
			</ul>
		</div>
		<div class="mainContent">			
			<h1>Hello ${c.userid}</h1>
			<div id="rotatingDiv"><img src=${c.image}></div>
			<button type="button" id="mainButton" class="btn btn-danger btn-large">Do a barrel roll!</button>
		</div>
	</div>
</body>
</html>
