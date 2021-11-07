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
//

#include <stdio.h>
#include <string.h>
int main()
{
	int arr0[10];
	char arr1[] = { "china is good"};
	int* p;
	int i,m;
	p = &arr0[0];
	int num_of_arr0 = sizeof(arr0) / sizeof(arr0[0]);
	//printf("byte of int =: %d\n",sizeof(int));
	//printf("byte of arr0 =: %d\n", sizeof(arr0));
	printf("byte of arr1 =: %d\n", sizeof(arr1));
	//printf("number of arr0 =: %d\n", num_of_arr0);
	printf("address of arr0 =: %p\n", arr0);
	printf("address of arr0 =: %p\n", p);
	for (i = 1; i <= num_of_arr0; i++)
		printf("address of arr0[%d] =: %p\n",i-1,&arr0[i-1]);
	for (m = 1; m <=sizeof(arr1); m++)
		printf("character of arr1[%d] =: %c\n", m-1, arr1[m-1]);


	return 0;
}
