import 'package:nf_og/model/catergory.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel = CategoryModel(
    categoryName: 'Business',
    imageUrl:
        'https://th.bing.com/th/id/R.3549703633e458f5a20f1e81fb7663c9?rik=614O6BBkCwcvkA&riu=http%3a%2f%2fecceconferences.org%2fwp-content%2fuploads%2f2017%2f11%2fbusiness-consulting2.jpg&ehk=JWalvpDJsejii3wDi%2bUQdGzz7fX%2f2tyt20bFK11QVtQ%3d&risl=&pid=ImgRaw&r=0',
  );

  category.add(categoryModel);

  categoryModel = CategoryModel(
    categoryName: 'Entertainment',
    imageUrl:
        'https://images.unsplash.com/photo-1499364615650-ec38552f4f34?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1372&q=80',
  );

  category.add(categoryModel);

  // categoryModel = CategoryModel(
  //   categoryName: 'General',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1451187580459-43490279c0fa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1172&q=80',
  // );

  // category.add(categoryModel);

  categoryModel = CategoryModel(
    categoryName: 'Health',
    imageUrl:
        'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=799&q=80',
  );

  category.add(categoryModel);

  categoryModel = CategoryModel(
    categoryName: 'Science',
    imageUrl:
        'https://images.unsplash.com/photo-1507413245164-6160d8298b31?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
  );

  category.add(categoryModel);

  categoryModel = CategoryModel(
    categoryName: 'Sports',
    imageUrl:
        'https://images.unsplash.com/photo-1523497804259-88c4c134ca90?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1288&q=80',
  );

  category.add(categoryModel);

  categoryModel = CategoryModel(
    categoryName: 'Technology',
    imageUrl:
        'https://images.unsplash.com/photo-1488590528505-98d2b5aba04b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
  );

  category.add(categoryModel);

  return category;
}
