// The anchor targets are hidden by 40px fixed position nav bar
// The following lines are an solution for this problem.
// @reference https://github.com/twitter/bootstrap/issues/1768#issuecomment-13306753
// But, scrollBy (relative) did not work well on safari, and I found that scrollTo (absolute) works.
// But, I realized that I have to compute offsetTop by recursively traversing parent objects, it is bothersome.
// So, I switched into jquery code, and the following is the final solution for this.
//
// Previously, we referred to the following for this problem. 
// @reference http://hail2u.net/blog/webdesign/target-pseudo-class-and-padding-top.html
// But, this broke layouts when we click anchors in a table.
//
// More previously, we referred to the following for this problem. 
// @reference http://stackoverflow.com/questions/9047703/fixed-position-navbar-obscures-anchors
// But this is not good because the above blocks are hidden by this padding.
$(function() {
  $(window).hashchange(function(){
    var pos = $("a[name='" + location.hash.substr(1) + "']").offset().top;
    // $('html, body').animate({ scrollTop: pos - 40 }, 0); // does not jump well on page load on safari
    // $('html, body').animate({ scrollTop: pos - 40 }, 1); // works, but have to wait 1ms
    window.scrollTo(0, pos - 40); // worked on safari, chrome, firefox well
  });
  // trigger the event on page load.
  if (location.hash) { $(window).hashchange(); }
});
