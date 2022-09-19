class SocialUser {
  SocialUser({
    required this.name,
    required this.phone,
    required this.image,
    required this.bio,
  });

  String? name;
  String? phone;

  String? image;

  String? bio;

  SocialUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    image = json['image'];
    bio = json['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "phone": phone,
      "image": image,
      "bio": bio,
    };
  }
}
