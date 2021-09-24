String _endpoint = "https://api.mytritek.co.uk/v1";

/*
 * Get all available courses
 */
String coursesEndpoint = "$_endpoint/courses";

/*
 * Get all available courses
 */
String playEndpoint = "$_endpoint/video/";

/*
 * Get all available courses
 */
String pingEndpoint = "$_endpoint/ping";

/*
 * Get all User courses, user id must be supplied
 */
String myCoursesEndpoint = "$_endpoint/my/courses/";
String commentEndpoint = "$_endpoint/comment_post";

/*
 * Post Login request
 */
String loginEndpoint = "$_endpoint/login";
String loginGoogleEndpoint = "$_endpoint/google/login";

/*
 * Post Login request
 */
String registerEndpoint = "$_endpoint/signup";

/*
 * Post Login request
 */
String editUserEndpoint = "$_endpoint/user";

/*
 * Post Login request
 */
String resetPasswordEndpoint = "$_endpoint/reset";

/*
 * Post Login request
 */
String passwordEndpoint = "$_endpoint/password";
String passwordChangeEndpoint = "$_endpoint/change/password";

/*
 * Post Login request
 */
String verifyEndpoint = "$_endpoint/verify";

/*
 * Get all testimonials
 */
String testimonialEndpoint = "$_endpoint/testimonial";

/*
 * Get Item Quiz questions. item Id must be supplied
 */
String quizEndpoint = "$_endpoint/questions/";

/*
 * Get all user viewed lessons. course Id must be supplied
 */
String viewedEndpoint = "$_endpoint/views/";
/*
 * Get all user viewed lessons. course Id must be supplied
 */
String levelEndpoint = "$_endpoint/points/";

/*
 * Get all user viewed lessons. course Id must be supplied
 */
String subsEndpoint = "$_endpoint/subs/";
String bankEndpoint = "$_endpoint/bank";
String paypalConfEndpoint = "$_endpoint/paypal/conf/";
String agentsEndpoint = "$_endpoint/agents/";

String secretEndpoint = "$_endpoint/stripe/secret";
String paymentLogEndpoint = "$_endpoint/payment/success";

/*
* Notes Api Calls
 */
String notesEndpoint = "$_endpoint/notes";
String editNoteEndpoint = "$_endpoint/note/edit";
String syncNoteEndpoint = "$_endpoint/notes/sync";
String deleteNoteEndpoint = "$_endpoint/note/delete/";
String deleteAllNotesEndpoint = "$_endpoint/notes/delete";

/*
* WishList Api Calls
 */
String wishListEndpoint = "$_endpoint/wishlist";
String saveListEndpoint = "$_endpoint/wishlist/save";
String deleteListEndpoint = "$_endpoint/wishlist/delete/";