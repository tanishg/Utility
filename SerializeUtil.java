import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

class SerializeUtil {

	ByteArrayInputStream inStream;
	ByteArrayOutputStream outStream;
	ObjectInputStream inputStream;
	ObjectOutputStream outputStream;

	public byte[] serializeObj(Object obj) throws IOException {
		try {
			outStream = new ByteArrayOutputStream();
			outputStream = new ObjectOutputStream(outStream);
			outputStream.writeObject(obj);
			outputStream.flush();
			return outStream.toByteArray();
		} finally {
			outputStream.close();
			outStream.close();
		}
	}

	public Object deserializeObj(byte[] bytes) throws IOException, ClassNotFoundException {
		try {
			inStream = new ByteArrayInputStream(bytes);
			inputStream = new ObjectInputStream(inStream);
			return inputStream.readObject();
		} finally {
			inputStream.close();
			inStream.close();
		}
	}
}
