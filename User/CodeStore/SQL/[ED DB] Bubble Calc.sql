Jay Cee - Today at 10:41 AM
@Arsen Cross - according to my math, it's 5.157859597255435ly from Pikum to Lembava
??(??1,??2)=v(??2 -??1)2 +(??2 -??1)2 +(??2 -??1)2
is the equation I used
Lembava    -43.25    -64.34375    -77.6875
Pikum    -39    -63.125    -75.03125
That's not too clear, this is better

Arsen Cross - Today at 10:46 AM
My math skills are algebra at best. Sp question when I see =v does that mean we are dividing the results of d(p1,p2) by the resulsts of the second string?
Jay Cee - Today at 10:47 AM
so d (P1, P2) is the distance (d) between place 1 and place 2
so you do the calc in the brackets squared, then add them together, then do the square root of the result

Arsen Cross - Today at 10:51 AM
Ok... so I understand this part...

(??2 -??1)2 +(??2 -??1)2 +(??2 -??1)2

The results of just that above - do I also square root that?
Jay Cee - Today at 10:52 AM
you only square root the result of the that, that number will be d
Arsen Cross - Today at 10:52 AM
ok... Where are P1 & P2 coming into play from?
Jay Cee - Today at 10:53 AM
it's just signifying that the answer (d) is the distance between those 2 points, you can ignore them for the equation
Arsen Cross - Today at 10:53 AM
Gotcha ok
So for the sake of my simpletons mind...

(??2 -??1)2 +(??2 -??1)2 +(??2 -??1)2 = result2
Jay Cee - Today at 10:54 AM
yeah, pretty much
Jay Cee - Today at 11:02 AM
So when trying to work about a bubble you can automatically discard anything where any one of the first parts in the brackets is greater than 15
Arsen Cross - Today at 11:03 AM
so if the first x-x squared is greater than 15... I can discard without proceeding to the rest of the calculations?
Jay Cee - Today at 11:04 AM
Before it's squared, if any x2 -x1 or y2 - y1 or z2-z1 is more than 15 it can be discarded
So if x is less than 15, move to y, if that's then greater it will fail
You can probably be more efficient than having to do the full calc though as if x is 15 and y is greater than 0 it's a fail.
Arsen Cross - Today at 11:07 AM
Lembava    -43.25    -64.34375    -77.6875
Pikum    -39    -63.125    -75.03125

So... Lembava vs Pikum x1-x2....

-43.25 - -39= -4.25

This is under positive 15, so I would not discard?
Jay Cee - Today at 11:09 AM
You can ignore the fact that's it's a negative. Just if the number is greater than 15 either 15 or more or negative 15 or less
Arsen Cross - Today at 11:09 AM
got it so it's basically a window of -15 to 15
Jay Cee - Today at 11:09 AM
Anyway the answer to that is positive 4.25 not negative
Arsen Cross - Today at 11:10 AM
I got -4.25 with a calculator

Jay Cee - Today at 11:12 AM
sorry, yes as you went Pikum to Lembava, not Lembava to Pikum :smiley:
you have a window of -15 to 15
it's x2 - x1
Arsen Cross - Today at 11:15 AM
Gotcha ok
Jay Cee - Today at 11:15 AM
coolio :smiley:
So you could do a search like = find all systems where x2 - x1  < 15, then with that result find all systems where y2 - y1 < 15 etc. You can then do fine grain calc on the remainder
function strictlyLessThan(p1,p2){
  return p1[0] < p2[0] && p1[1] < p2[1] && p1[2] < p2[2];
}

// iterations
var it = 0;

function f(ps){
  var res = 0,
      indexes = new Array(ps.length);

  // sort by x
  var sortedX = 
        ps.map(function(x,i){ return i; })
          .sort(function(a,b){ return ps[a][0] - ps[b][0]; });

  // record index of point in x-sorted list
  for (var i=0; i<sortedX.length; i++){
    indexes[sortedX[i]] = [i,null,null];
  }

  // sort by y
  var sortedY = 
        ps.map(function(x,i){ return i; })
          .sort(function(a,b){ return ps[a][1] - ps[b][1]; });

  // record index of point in y-sorted list
  for (var i=0; i<sortedY.length; i++){
    indexes[sortedY[i]][1] = i;
  }(edited)
// sort by z
  var sortedZ = 
        ps.map(function(x,i){ return i; })
          .sort(function(a,b){ return ps[a][2] - ps[b][2]; });

  // record index of point in z-sorted list
  for (var i=0; i<sortedZ.length; i++){
    indexes[sortedZ[i]][2] = i;
  }

  // check for possible greater points only in the list
  // where the point is highest
  for (var i=0; i<ps.length; i++){
    var listToCheck,
        startIndex;

    if (indexes[i][0] > indexes[i][1]){
      if (indexes[i][0] > indexes[i][2]){
        listToCheck = sortedX;
        startIndex = indexes[i][0];
      } else {
        listToCheck = sortedZ;
        startIndex = indexes[i][2];
      }

    } else {
      if (indexes[i][1] > indexes[i][2]){
        listToCheck = sortedY;
        startIndex = indexes[i][1];
      } else {
        listToCheck = sortedZ;
        startIndex = indexes[i][2];
      }
    }

    var j = startIndex + 1;
 
    while (listToCheck[j] !== undefined){
      it++;
      var point = ps[listToCheck[j]];
 
      if (strictlyLessThan(ps[i],point)){
        res++;
        break;
      }
      j++;
    }
  }

  return res;
}

// var input = [[5,0,0],[4,1,0],[3,2,0],[2,3,0],[1,4,0],[0,5,0],[4,0,1],[3,1,1], [2,2,1],[1,3,1],[0,4,1],[3,0,2],[2,1,2],[1,2,2],[0,3,2],[2,0,3], [1,1,3],[0,2,3],[1,0,4],[0,1,4],[0,0,5]];

var input = new Array(10000);

for (var i=0; i<input.length; i++){
  input[i] = [Math.random(),Math.random(),Math.random()];
}

console.log(input.length + ' points');
console.log('result: ' + f(input));
console.log(it + ' iterations not including sorts');