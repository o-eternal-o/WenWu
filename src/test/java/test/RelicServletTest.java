package test;

import com.DAO.RelicDAO;
import com.SQL.Relic_Bean;
import com.admin.RelicServlet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

class RelicServletTest {
    private RelicServlet relicServlet;
    private HttpServletRequest mockRequest;
    private HttpServletResponse mockResponse;
    private RequestDispatcher mockDispatcher;
    private RelicDAO mockRelicDAO;

    @BeforeEach
    void setUp() {
        mockRequest = mock(HttpServletRequest.class);
        mockResponse = mock(HttpServletResponse.class);
        mockDispatcher = mock(RequestDispatcher.class);
        mockRelicDAO = mock(RelicDAO.class);

        relicServlet = new RelicServlet();
        relicServlet.relicDAO = mockRelicDAO;
    }

    @Test
    void testListRelics() throws Exception {
        List<Relic_Bean> mockRelicList = Arrays.asList(new Relic_Bean(), new Relic_Bean());
        when(mockRelicDAO.listRelics()).thenReturn(mockRelicList);
        when(mockRequest.getParameter("action")).thenReturn("list");
        when(mockRequest.getRequestDispatcher("/admin/relic_list.jsp")).thenReturn(mockDispatcher);

        relicServlet.doPost(mockRequest, mockResponse);

        verify(mockRelicDAO).listRelics();
        verify(mockRequest).setAttribute("relicList", mockRelicList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testSearchRelics() throws Exception {
        List<Relic_Bean> mockRelicList = Collections.singletonList(new Relic_Bean());
        when(mockRequest.getParameter("action")).thenReturn("search");
        when(mockRequest.getParameter("searchType")).thenReturn("dynasty");
        when(mockRequest.getParameter("searchInput")).thenReturn("Tang");
        when(mockRelicDAO.searchRelics("dynasty", "Tang")).thenReturn(mockRelicList);
        when(mockRequest.getRequestDispatcher("/admin/relic_list.jsp")).thenReturn(mockDispatcher);

        relicServlet.doPost(mockRequest, mockResponse);

        verify(mockRelicDAO).searchRelics("dynasty", "Tang");
        verify(mockRequest).setAttribute("relicList", mockRelicList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testAddRelic() throws Exception {
        Part mockPart = mock(Part.class);
        when(mockRequest.getParameter("action")).thenReturn("add");
        when(mockRequest.getParameter("relicName")).thenReturn("Test Relic");
        when(mockRequest.getParameter("dynasty")).thenReturn("Tang");
        when(mockRequest.getParameter("description")).thenReturn("Test Description");
        when(mockRequest.getParameter("hallId")).thenReturn("1");
        when(mockRequest.getParameter("createdBy")).thenReturn("1");
        when(mockRequest.getPart("imageFile")).thenReturn(mockPart);

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        relicServlet.doPost(mockRequest, mockResponse);

        ArgumentCaptor<Relic_Bean> captor = ArgumentCaptor.forClass(Relic_Bean.class);
        verify(mockRelicDAO).addRelic(captor.capture());
        Relic_Bean capturedRelic = captor.getValue();

        assertEquals("Test Relic", capturedRelic.getRelicName());
        assertEquals("Tang", capturedRelic.getDynasty());
        assertEquals("Test Description", capturedRelic.getDescription());
        assertEquals(1, capturedRelic.getHallId());
        assertEquals(1, capturedRelic.getCreatedBy());

        verify(mockWriter).write("success");
    }

    @Test
    void testEditRelic() throws Exception {
        Relic_Bean mockRelic = new Relic_Bean();
        when(mockRequest.getParameter("action")).thenReturn("edit");
        when(mockRequest.getParameter("relicId")).thenReturn("1");
        when(mockRelicDAO.getRelicById(1)).thenReturn(mockRelic);
        when(mockRequest.getRequestDispatcher("/admin/function/relic_edit.jsp")).thenReturn(mockDispatcher);

        relicServlet.doPost(mockRequest, mockResponse);

        verify(mockRelicDAO).getRelicById(1);
        verify(mockRequest).setAttribute("relic", mockRelic);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testUpdateRelic() throws Exception {
        Part mockPart = mock(Part.class);
        when(mockRequest.getParameter("action")).thenReturn("update");
        when(mockRequest.getParameter("relicId")).thenReturn("1");
        when(mockRequest.getParameter("relicName")).thenReturn("Updated Relic");
        when(mockRequest.getParameter("dynasty")).thenReturn("Song");
        when(mockRequest.getParameter("description")).thenReturn("Updated Description");
        when(mockRequest.getParameter("hallId")).thenReturn("2");
        when(mockRequest.getParameter("createdBy")).thenReturn("2");
        when(mockRequest.getPart("imageFile")).thenReturn(mockPart);

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        relicServlet.doPost(mockRequest, mockResponse);

        ArgumentCaptor<Relic_Bean> captor = ArgumentCaptor.forClass(Relic_Bean.class);
        verify(mockRelicDAO).updateRelic(captor.capture());
        Relic_Bean capturedRelic = captor.getValue();

        assertEquals(1, capturedRelic.getRelicId());
        assertEquals("Updated Relic", capturedRelic.getRelicName());
        assertEquals("Song", capturedRelic.getDynasty());
        assertEquals("Updated Description", capturedRelic.getDescription());
        assertEquals(2, capturedRelic.getHallId());
        assertEquals(2, capturedRelic.getCreatedBy());

        verify(mockWriter).write("success");
    }

    @Test
    void testDeleteRelic() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("delete");
        when(mockRequest.getParameter("relicId")).thenReturn("1");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        relicServlet.doPost(mockRequest, mockResponse);

        verify(mockRelicDAO).deleteRelic(1);
        verify(mockWriter).write("success");
    }
}
