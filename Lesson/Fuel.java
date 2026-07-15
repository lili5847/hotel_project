import java.util.Scanner;

public class Fuel {
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		double distance;
		double kiloPerLiter;
		double pricePerliter;
		double totalPrice;
		
		System.out.print("Enter the driving Distance: ");
		distance = scanner.nextDouble();
		
		System.out.print("Enter Kilometers Per liter: ");
		kiloPerLiter = scanner.nextDouble();
		
		System.out.print("Enter Price per liter: ");
		pricePerliter = scanner.nextDouble();
		
		totalPrice = (distance / kiloPerLiter) * pricePerliter;
		
		System.out.print("The cost of driving is $" + totalPrice);
		scanner.close();
	}

}
