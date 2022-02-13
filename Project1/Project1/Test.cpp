#define _CRT_SECURE_NO_WARNINGS 1
#include <stdio.h>

//int main()
//{
//	int read = 0;
//	scanf("%d",&read);
//	printf("hello word ,hell c\n");
//	printf("input is : %d\n",read );
//	printf("%d\n",++read);
//	printf("%d\n", read++);
//	printf("%d\n", read += read++);
//	//printf("%d\n", read = read + read++);
//
//	return 0;
////
//
//#include <stdio.h>
//#include <string.h>
////int main()
////{
////	int arr0[10];
//	char arr1[] = { "china is good"};
//	int* p;
//	int i,m;
//	p = &arr0[0];
//	int num_of_arr0 = sizeof(arr0) / sizeof(arr0[0]);
//	//printf("byte of int =: %d\n",sizeof(int));
//	//printf("byte of arr0 =: %d\n", sizeof(arr0));
//	printf("byte of arr1 =: %d\n", sizeof(arr1));
//	//printf("number of arr0 =: %d\n", num_of_arr0);
//	printf("address of arr0 =: %p\n", arr0);
//	printf("address of arr0 =: %p\n", p);
//	for (i = 1; i <= num_of_arr0; i++)
//		printf("address of arr0[%d] =: %p\n",i-1,&arr0[i-1]);
//	for (m = 1; m <=sizeof(arr1); m++)
//		printf("character of arr1[%d] =: %c\n", m-1, arr1[m-1]);
//
//	return 0;
////}
//
//#include <stdio.h>
//
////int main()
////{
//	int i = 5, m ;
//	float j = 1.0, k = 1.0;
//	float Float = 5.32f;
//	printf("float is ++ = :%f\n", ++Float);
//	printf("float is -- = :%f\n",--Float);
////	printf("%d %d", i / j, i % j);
//	printf("%d", (i + 10) % j);
//	printf("%d", (i + 10) % k /j );
//	printf("%d %d", (-i) /j, -(i / j) );
//	printf("%d %d\n", i / 10, i % 10 );
//	printf("%d %d\n", i / 100, i % 100);
//	i += j += k;
//	j = 6 + (i = 2.5);
//	printf("%d %f\n", i, j );
//	m = ++i * 3 - 2;
//	printf("%d %d\n", i );
	//printf("++i = :%d \n", ++i );
	//i = 5;
//	//printf("i++ = :%d \n", i++ );
//	//i = 5;
//	//printf("i += 1:%d \n", i += 1 );
//	return 0;
//}

	//int main()
	//{
	//	int input, i , j, k;
	//	printf("Enter a three-digit number: ");
	//	scanf("%d",&input);
	//	i = input % 10;
	//	j = input / 10 % 10;
	//	k = input / 100;
	//	printf("The reversal is :%d%d%d\n", i, j , k );
	//	return 0;
	////}

int main()
{
	int input=0;
	int i = 1, num=0, in = 0;
//	int a, b, c, d, e;
	printf("Enter a number between 0 and 32762 :");
	scanf("%d", &input);
	in = input;
	//a = input % 8;
	//input /= 8;
	//b = input % 8;
	//input /= 8;
	//c = input % 8;
	//input /= 8;
	//d = input % 8;
	//input /= 8;
	//e = input % 8;
	while (in != 0)
	{
		num += in % 8 * i;
		in  /= 8;
		i *= 10;
	}
	printf("In octal,your number is : %05d\n",num ); //“%0位宽d”输出数字不足位宽要求时，前端补“0”
	printf("In octal,your number is : %05o\n",input);
	return 0;
}