package ss2_loop_in_java.Exercises;

import com.sun.xml.internal.ws.api.model.wsdl.WSDLOutput;

import java.util.Scanner;

public class DisplayPrimeNumber {
    public static void main(String[] args) {
        System.out.print("Enter the mount of prime number: ");
        Scanner scanner = new Scanner(System.in);
        int mountPrimeNumber = scanner.nextInt();
        System.out.print("The first " + mountPrimeNumber + " primes are: ");
        int number = 2;
        int countNumber = 0;
        while (countNumber < mountPrimeNumber) {
            int count = 0;
            for (int i = 1; i <= number; i++) {
                if (number % i == 0) {
                    count++;
                }
            }
            if (count == 2) {
                System.out.print(number + ",");
                countNumber++;
            }
            number++;
        }
    }
}

